# Welcome to the Bongonet Discussions

This is the community space for [Bongonet](https://github.com/netbpf/bongonet) — an async Rust
networking stack for building fast, secure, and programmable proxies and network services.

## What Bongonet is

Bongonet is a Rust workspace of composable crates for building proxy and network applications. It
provides an async runtime, HTTP/1 and HTTP/2 proxying with filters, pluggable TLS backends, load
balancing, health checks, connection pooling, rate limiting, graceful reload, and observability
hooks. You can use the public `bongonet` crate directly or pick individual crates for the pieces
you need.

## Project at a glance

| | |
| --- | --- |
| Current release | `0.4.0` |
| Crates in workspace | 24 (under `crates/`) |
| License | Apache-2.0 |
| Rust MSRV | 1.85 (`bongonet-foundations` requires 1.88) |
| Platforms | Linux (Tier 1), macOS (partial), Windows (best-effort) |
| Architectures | `x86_64`, `aarch64` |
| TLS backends | OpenSSL, BoringSSL, rustls, s2n-tls (optional Cargo features) |

## Getting started

- [Quick start: build a load balancer](https://github.com/netbpf/bongonet/blob/main/docs/quick_start.md)
- [User guide](https://github.com/netbpf/bongonet/blob/main/docs/user_guide/index.md)
- [API docs on docs.rs](https://docs.rs/bongonet)
- From a source checkout: `make bootstrap`, `make check`, `make test`, `make help`

## How to use these Discussions

| Category | Use it for |
| --- | --- |
| Announcements | Release notes and important project news (maintainers only) |
| Questions | Usage and troubleshooting questions — the `questions.yml` template will guide you |
| Ideas | Feature proposals and design discussions before you write code |
| Show and tell | Projects, extensions, and integrations built with Bongonet |
| General | Everything else |

## Before you post

1. Search existing discussions and [issues](https://github.com/netbpf/bongonet/issues) first.
2. For reproducible bugs and feature requests, open a GitHub issue using the issue templates
   instead of a discussion — issues keep implementation work trackable.
3. Include your Bongonet version, Rust version, OS, and a minimal reproduction where relevant.
4. Be respectful and follow the
   [Contributor Covenant Code of Conduct](https://github.com/netbpf/.github/blob/26b37ca2ba7ab3d91050ead9f2c0e30674d3b91e/CODE_OF_CONDUCT.md).

## Contributing and support

Read the [Contribution Guidelines](https://github.com/netbpf/bongonet/blob/main/.github/CONTRIBUTING.md)
before opening a PR. Non-trivial changes should start with an issue. For direct questions, contact
[opensource@khulnasoft.com](mailto:opensource@khulnasoft.com).
