# Bongonet Internals

(Special thanks to [James Munns](https://github.com/jamesmunns) for writing this section)


## Starting the `Server`

The bongonet system starts by spawning a *server*. The server is responsible for starting *services*, and listening for termination events.

```
                               ┌───────────┐
                    ┌─────────>│  Service  │
                    │          └───────────┘
┌────────┐          │          ┌───────────┐
│ Server │──Spawns──┼─────────>│  Service  │
└────────┘          │          └───────────┘
                    │          ┌───────────┐
                    └─────────>│  Service  │
                               └───────────┘
```

After spawning the *services*, the server continues to listen to a termination event, which it will propagate to the created services.

## Services
flowchart TD
       start([New request]) --> request_filter[Request filter]
       request_filter -->|continue| upstream_peer[Select upstream peer]
       request_filter -->|send response| logging[Log request]

       subgraph upstream[Connect to upstream]
              direction TD
              upstream_peer --> connect{{Connect}}
              connect -->|success| connected[Connected]
              connect -->|failure| fail_to_connect[Connection failed]
              connected --> upstream_request_filter[Upstream request filter]
              upstream_request_filter --> send_request{{Send request}}
              send_request -->|success| read_response{{Read response}}
              read_response -->|success| upstream_response_filter[Upstream response filter]
              upstream_response_filter --> response_filter[Response filter]
              response_filter --> upstream_response_body_filter[Upstream response body filter]
              upstream_response_body_filter --> response_body_filter[Response body filter]
              response_body_filter --> logging
       end

       fail_to_connect -->|retry| upstream_peer
       fail_to_connect -->|stop| fail_to_proxy[Create error response]
       send_request -->|I/O failure| io_failure[I/O error]
       read_response -->|I/O failure| io_failure
       upstream_response_filter -->|filter error| proxy_error[Proxy error]
       response_filter -->|filter error| proxy_error
       upstream_response_body_filter -->|filter error| proxy_error
       response_body_filter -->|filter error| proxy_error
       io_failure --> proxy_error
       proxy_error -->|retry| upstream_peer
       proxy_error -->|stop| fail_to_proxy
       fail_to_proxy --> logging
       logging --> done([Request complete])

       classDef io fill:#fff3cd,stroke:#b58105,color:#332900
       classDef error fill:#f8d7da,stroke:#a52834,color:#58151c
       classDef complete fill:#d1e7dd,stroke:#146c43,color:#0a3622
       class connect,send_request,read_response io
       class fail_to_connect,io_failure,proxy_error,fail_to_proxy error
       class start,done complete
       style upstream fill:#f5f7fa,stroke:#64748b,stroke-width:1px

## Service Listeners

At startup, each Service is assigned a set of downstream endpoints that they listen to. A single service may listen to more than one endpoint. The Server also passes along any relevant configuration, including TLS settings if relevant.

These endpoints are converted into listening sockets, called `TransportStack`s. Each `TransportStack` is assigned to an async task within that service's executor.

```
                                 ┌───────────────────┐
                                 │┌─────────────────┐│    ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─
 ┌─────────┐                     ││ TransportStack  ││                                ┌────────────────────┐│
┌┤Listeners├────────┐            ││                 ││    │                       │  ││                    │
│└─────────┘        │            ││ (Listener, TLS  │├──────spawn(run_endpoint())────>│ Service<ServerApp> ││
│┌─────────────────┐│            ││    Acceptor,    ││    │                       │  ││                    │
││    Endpoint     ││            ││   UpgradeFDs)   ││                                └────────────────────┘│
││   addr/ports    ││            │├─────────────────┤│    │                       │  │
││ + TLS Settings  ││            ││ TransportStack  ││                                ┌────────────────────┐│
│├─────────────────┤│            ││                 ││    │                       │  ││                    │
││    Endpoint     ││──build()─> ││ (Listener, TLS  │├──────spawn(run_endpoint())────>│ Service<ServerApp> ││
││   addr/ports    ││            ││    Acceptor,    ││    │                       │  ││                    │
││ + TLS Settings  ││            ││   UpgradeFDs)   ││                                └────────────────────┘│
│├─────────────────┤│            │├─────────────────┤│    │                       │  │
││    Endpoint     ││            ││ TransportStack  ││                                ┌────────────────────┐│
││   addr/ports    ││            ││                 ││    │                       │  ││                    │
││ + TLS Settings  ││            ││ (Listener, TLS  │├──────spawn(run_endpoint())────>│ Service<ServerApp> ││
│└─────────────────┘│            ││    Acceptor,    ││    │                       │  ││                    │
└───────────────────┘            ││   UpgradeFDs)   ││                                └────────────────────┘│
                                 │└─────────────────┘│    │ ┌───────────────┐     │  │ ┌──────────────┐
                                 └───────────────────┘     ─│start_service()│─ ─ ─    ─│ Worker Tasks ├ ─ ─ ┘
                                                            └───────────────┘          └──────────────┘
```

## Downstream connection lifecycle

Each service processes incoming connections by spawning a task-per-connection. These connections are held open
as long as there are new events to be handled.

```
                                  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐

                                  │  ┌───────────────┐   ┌────────────────┐   ┌─────────────────┐    ┌─────────────┐  │
┌────────────────────┐               │ UninitStream  │   │    Service     │   │       App       │    │  Task Ends  │
│                    │            │  │ ::handshake() │──>│::handle_event()│──>│ ::process_new() │──┬>│             │  │
│ Service<ServerApp> │──spawn()──>   └───────────────┘   └────────────────┘   └─────────────────┘  │ └─────────────┘
│                    │            │                                                    ▲           │                  │
└────────────────────┘                                                                 │         while
                                  │                                                    └─────────reuse                │
                                     ┌───────────────────────────┐
                                  └ ─│  Task on Service Runtime  │─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
                                     └───────────────────────────┘
```

## What is a proxy then?

Interestingly, the `bongonet` `Server` itself has no particular notion of a Proxy.

Instead, it only thinks in terms of `Service`s, which are expected to contain a particular implementor of the `ServiceApp` trait.

For example, this is how an `HttpProxy` struct, from the `bongonet-proxy` crate, "becomes" a `Service` spawned by the `Server`:

```
┌─────────────┐
│  HttpProxy  │
│  (struct)   │
└─────────────┘
       │
   implements   ┌─────────────┐
       │        │HttpServerApp│
       └───────>│   (trait)   │
                └─────────────┘
                       │
                   implements   ┌─────────────┐
                       │        │  ServerApp  │
                       └───────>│   (trait)   │
                                └─────────────┘
                                       │
                                   contained    ┌─────────────────────┐
                                     within     │                     │
                                       └───────>│ Service<ServiceApp> │
                                                │                     │
                                                └─────────────────────┘
```

Different functionalities and helpers are provided at different layers in this representation.

```
┌─────────────┐        ┌──────────────────────────────────────┐
│  HttpProxy  │        │Handles high level Proxying workflow, │
│  (struct)   │─ ─ ─ ─ │   customizable via ProxyHttp trait   │
└──────┬──────┘        └──────────────────────────────────────┘
       │
┌──────▼──────┐        ┌──────────────────────────────────────┐
│HttpServerApp│        │ Handles selection of H1 vs H2 stream │
│   (trait)   │─ ─ ─ ─ │     handling, incl H2 handshake      │
└──────┬──────┘        └──────────────────────────────────────┘
       │
┌──────▼──────┐        ┌──────────────────────────────────────┐
│  ServerApp  │        │ Handles dispatching of App instances │
│   (trait)   │─ ─ ─ ─ │   as individual tasks, per Session   │
└──────┬──────┘        └──────────────────────────────────────┘
       │
┌──────▼──────┐        ┌──────────────────────────────────────┐
│ Service<A>  │        │ Handles dispatching of App instances │
│  (struct)   │─ ─ ─ ─ │  as individual tasks, per Listener   │
└─────────────┘        └──────────────────────────────────────┘
```

The `HttpProxy` struct handles the high level workflow of proxying an HTTP connection

It uses the `ProxyHttp` (note the flipped wording order!) **trait** to allow customization
at each of the following steps (note: taken from [the phase chart](./phase_chart.md) doc):

```mermaid
 graph TD;
    start("new request")-->request_filter;
    request_filter-->upstream_peer;

    upstream_peer-->Connect{{IO: connect to upstream}};

    Connect--connection success-->connected_to_upstream;
    Connect--connection failure-->fail_to_connect;

    connected_to_upstream-->upstream_request_filter;
    upstream_request_filter --> SendReq{{IO: send request to upstream}};
    SendReq-->RecvResp{{IO: read response from upstream}};
    RecvResp-->upstream_response_filter-->response_filter-->upstream_response_body_filter-->response_body_filter-->logging-->endreq("request done");

    fail_to_connect --can retry-->upstream_peer;
    fail_to_connect --can't retry-->fail_to_proxy--send error response-->logging;

    RecvResp--failure-->IOFailure;
    SendReq--failure-->IOFailure;
    error_while_proxy--can retry-->upstream_peer;
    error_while_proxy--can't retry-->fail_to_proxy;

    request_filter --send response-->logging


    Error>any response filter error]-->error_while_proxy
    IOFailure>IO error]-->error_while_proxy

```

## Zooming out

Before we zoom in, it's probably good to zoom out and remind ourselves how
a proxy generally works:

```
┌────────────┐          ┌─────────────┐         ┌────────────┐
│ Downstream │          │    Proxy    │         │  Upstream  │
│   Client   │─────────>│             │────────>│   Server   │
└────────────┘          └─────────────┘         └────────────┘
```

The proxy will be taking connections from the **Downstream** client, and (if
everything goes right), establishing a connection with the appropriate
**Upstream** server. This selected upstream server is referred to as
the **Peer**.

Once the connection is established, the Downstream and Upstream can communicate
bidirectionally.

So far, the discussion of Server, Services, and Listeners have focused on the LEFT
half of this diagram, handling incoming Downstream connections, and getting it TO
the proxy component.

Next, we'll look at the RIGHT half of this diagram, connecting to Upstreams.

## Managing the Upstream

Connections to Upstream Peers are made through `Connector`s. This is not a specific type or trait, but more
of a "style".

Connectors are responsible for a few things:

* Establishing a connection with a Peer
* Maintaining a connection pool with the Peer, allowing for connection reuse across:
    * Multiple requests from a single downstream client
    * Multiple requests from different downstream clients
* Measuring health of connections, for connections like H2, which perform regular pings
* Handling protocols with multiple poolable layers, like H2
* Caching, if relevant to the protocol and enabled
* Compression, if relevant to the protocol and enabled

Now in context, we can see how each end of the Proxy is handled:

```
┌────────────┐          ┌─────────────┐         ┌────────────┐
│ Downstream │       ┌ ─│─   Proxy  ┌ ┼ ─       │  Upstream  │
│   Client   │─────────>│ │           │──┼─────>│   Server   │
└────────────┘       │  └───────────┼─┘         └────────────┘
                      ─ ─ ┘          ─ ─ ┘
                        ▲              ▲
                     ┌──┘              └──┐
                     │                    │
                ┌ ─ ─ ─ ─ ┐         ┌ ─ ─ ─ ─ ─
                 Listeners           Connectors│
                └ ─ ─ ─ ─ ┘         └ ─ ─ ─ ─ ─
```

## What about multiple peers?

`Connectors` only handle the connection to a single peer, so selecting one of potentially multiple Peers
is actually handled one level up, in the `upstream_peer()` method of the `ProxyHttp` trait.
