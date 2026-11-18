<h1 align="center">🚀 Bongonet</h1>

<p align="center">
  <strong>Async Rust networking stack for blazing-fast, secure, and programmable proxying</strong>
</p>

<p align="center">
  <a href="https://crates.io/crates/bongonet">
    <img src="https://img.shields.io/crates/v/bongonet.svg" alt="Crates.io version" />
  </a>
  <a href="https://github.com/netbpf/bongonet/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-Apache%202.0-blue.svg" alt="License: Apache 2.0" />
  </a>
  <img src="https://img.shields.io/badge/rustc-1.85+-orange.svg" alt="Rustc Version 1.85+" />
</p>

---

## ✨ Feature Highlights

- ⚡ **Async Rust**: Fast and reliable
- 🌐 **HTTP/1 & HTTP/2** end-to-end proxy
- 🔐 **TLS** over OpenSSL, BoringSSL, rustls or s2n-tls
- 🔄 **gRPC and WebSocket** proxying
- ♻️ **Graceful reload**
- 🎯 **Customizable load balancing** and failover strategies
- 📊 **Observability** support: metrics, tracing, and more
- Shared runtimes, service bootstrapping, custom HTTP backends and subrequests

---

## 🛡️ Reasons to Use Bongonet

- ✅ **Security-first**: Memory-safe Rust vs legacy C/C++ codebases
- 🚀 **High performance**: Optimized for low latency and high throughput
- 🔧 **Highly customizable**: Extensible APIs for tailor-made proxy logic

---

## 🚀 Getting Started

Start fast with our [Quick Start Guide](./docs/quick_start.md).

Explore more in the [User Guide](./docs/user_guide/index.md) — from running Bongonet servers to building custom proxy logic.

📚 **API Documentation** is available for all crates in the workspace.

All workspace members live under [`crates/`](./crates). To work on the project locally:

```sh
make bootstrap   # verify prerequisites and run a locked cargo check
make check       # formatting, check, clippy, tests and release build
make test        # run the workspace test suite
make help        # list all available commands
```

TLS backends are optional Cargo features: `openssl`, `boringssl`, `rustls` and `s2n`.

---

## 📦 Notable Crates

| Package | Description | Version | Docs |
| ------- | ----------- | ------- | ---- |
| `bongonet` | 🌐 Public-facing crate for proxy/networked systems | [![version](https://img.shields.io/crates/v/bongonet.svg)](https://crates.io/crates/bongonet) | [docs.rs](https://docs.rs/bongonet) |
| `bongonet-boringssl` | 🔒 SSL integration using BoringSSL | [![version](https://img.shields.io/crates/v/bongonet-boringssl.svg)](https://crates.io/crates/bongonet-boringssl) | [docs.rs](https://docs.rs/bongonet-boringssl) |
| `bongonet-cache` | 🧠 Generic cache structures and cache fill cancellation | [![version](https://img.shields.io/crates/v/bongonet-cache.svg)](https://crates.io/crates/bongonet-cache) | [docs.rs](https://docs.rs/bongonet-cache) |
| `bongonet-core` | 🔧 Protocols, traits, and core logic | [![version](https://img.shields.io/crates/v/bongonet-core.svg)](https://crates.io/crates/bongonet-core) | [docs.rs](https://docs.rs/bongonet-core) |
| `bongonet-error` | ⚠️ Shared error types across crates | [![version](https://img.shields.io/crates/v/bongonet-error.svg)](https://crates.io/crates/bongonet-error) | [docs.rs](https://docs.rs/bongonet-error) |
| `bongonet-foundations` | Foundations telemetry integration for services | [![version](https://img.shields.io/crates/v/bongonet-foundations.svg)](https://crates.io/crates/bongonet-foundations) | [docs.rs](https://docs.rs/bongonet-foundations) |
| `bongonet-header-serde` | 🧳 Header serialization/deserialization utilities | [![version](https://img.shields.io/crates/v/bongonet-header-serde.svg)](https://crates.io/crates/bongonet-header-serde) | [docs.rs](https://docs.rs/bongonet-header-serde) |
| `bongonet-http` | 🌐 HTTP headers and utilities | [![version](https://img.shields.io/crates/v/bongonet-http.svg)](https://crates.io/crates/bongonet-http) | [docs.rs](https://docs.rs/bongonet-http) |
| `bongonet-http-parser` | HTTP/1 parser compatibility layer | [![version](https://img.shields.io/crates/v/bongonet-http-parser.svg)](https://crates.io/crates/bongonet-http-parser) | [docs.rs](https://docs.rs/bongonet-http-parser) |
| `bongonet-ketama` | 🧭 Ketama consistent hashing | [![version](https://img.shields.io/crates/v/bongonet-ketama.svg)](https://crates.io/crates/bongonet-ketama) | [docs.rs](https://docs.rs/bongonet-ketama) |
| `bongonet-limits` | 🚦 Rate-limiting algorithms | [![version](https://img.shields.io/crates/v/bongonet-limits.svg)](https://crates.io/crates/bongonet-limits) | [docs.rs](https://docs.rs/bongonet-limits) |
| `bongonet-load-balancing` | ⚖️ Load balancing extensions | [![version](https://img.shields.io/crates/v/bongonet-load-balancing.svg)](https://crates.io/crates/bongonet-load-balancing) | [docs.rs](https://docs.rs/bongonet-load-balancing) |
| `bongonet-lru` | 🧮 LRU cache strategies for async systems | [![version](https://img.shields.io/crates/v/bongonet-lru.svg)](https://crates.io/crates/bongonet-lru) | [docs.rs](https://docs.rs/bongonet-lru) |
| `bongonet-memory-cache` | 🔒 Async memory cache with locking | [![version](https://img.shields.io/crates/v/bongonet-memory-cache.svg)](https://crates.io/crates/bongonet-memory-cache) | [docs.rs](https://docs.rs/bongonet-memory-cache) |
| `bongonet-openssl` | 🔐 SSL integration using OpenSSL | [![version](https://img.shields.io/crates/v/bongonet-openssl.svg)](https://crates.io/crates/bongonet-openssl) | [docs.rs](https://docs.rs/bongonet-openssl) |
| `bongonet-pool` | 💧 Async connection pool utilities | [![version](https://img.shields.io/crates/v/bongonet-pool.svg)](https://crates.io/crates/bongonet-pool) | [docs.rs](https://docs.rs/bongonet-pool) |
| `bongonet-prometheus` | Prometheus metrics HTTP server | [![version](https://img.shields.io/crates/v/bongonet-prometheus.svg)](https://crates.io/crates/bongonet-prometheus) | [docs.rs](https://docs.rs/bongonet-prometheus) |
| `bongonet-proxy` | 🔁 HTTP proxy logic and APIs | [![version](https://img.shields.io/crates/v/bongonet-proxy.svg)](https://crates.io/crates/bongonet-proxy) | [docs.rs](https://docs.rs/bongonet-proxy) |
| `bongonet-runtime` | 🕒 Runtime integration for network workloads | [![version](https://img.shields.io/crates/v/bongonet-runtime.svg)](https://crates.io/crates/bongonet-runtime) | [docs.rs](https://docs.rs/bongonet-runtime) |
| `bongonet-rustls` | 🔐 TLS integration using Rustls | [![version](https://img.shields.io/crates/v/bongonet-rustls.svg)](https://crates.io/crates/bongonet-rustls) | [docs.rs](https://docs.rs/bongonet-rustls) |
| `bongonet-s2n` | TLS integration using s2n-tls | [![version](https://img.shields.io/crates/v/bongonet-s2n.svg)](https://crates.io/crates/bongonet-s2n) | [docs.rs](https://docs.rs/bongonet-s2n) |
| `bongonet-test-utils` | Reusable HTTP and TCP test helpers | [![version](https://img.shields.io/crates/v/bongonet-test-utils.svg)](https://crates.io/crates/bongonet-test-utils) | [docs.rs](https://docs.rs/bongonet-test-utils) |
| `bongonet-timeout` | ⏲️ Efficient async timer utilities | [![version](https://img.shields.io/crates/v/bongonet-timeout.svg)](https://crates.io/crates/bongonet-timeout) | [docs.rs](https://docs.rs/bongonet-timeout) |
| `tinyufo` | TinyLFU admission and S3-FIFO cache | [![version](https://img.shields.io/crates/v/tinyufo.svg)](https://crates.io/crates/tinyufo) | [docs.rs](https://docs.rs/tinyufo) |

---

## 🧰 System Requirements

### 🖥️ Supported Platforms

- ✅ **Linux** (Tier 1)
- 💻 **macOS** (Partial support)
- 🪟 **Windows** (Best-effort by community)
- Supported Architectures: `x86_64`, `aarch64`

### 🦀 Rust Version

- MSRV: **1.85** (`bongonet-foundations` requires **1.88**)
- Rolling 6-month MSRV policy — upgrades allowed if Rust version is ≥ 6 months old

### 🛠️ Build Requirements

Some crates depend on external tools:

- 🔧 [Clang](https://clang.llvm.org/) (for BoringSSL)
- 🐪 [Perl 5](https://www.perl.org/) (for OpenSSL)
- CMake (for the optional s2n-tls backend)

---

## 🤝 Contributing

Check out our [Contribution Guidelines](./.github/CONTRIBUTING.md) to get involved.

---

## ⚖️ License

Licensed under the [Apache License, Version 2.0](./LICENSE).

---
