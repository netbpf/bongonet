FROM rust:1.92-bookworm AS builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends cmake libclang-dev clang pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN cargo generate-lockfile --ignore-rust-version \
    && cargo build --release --locked -p bongonet --example server

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /usr/sbin/nologin bongonet

COPY --from=builder /app/target/release/examples/server /usr/local/bin/bongonet

USER bongonet
EXPOSE 80 443
ENTRYPOINT ["/usr/local/bin/bongonet"]
