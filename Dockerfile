FROM rust:1.58.1 as builder

WORKDIR /app

# キャッシュ用対策
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock
RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN rustup default nightly
RUN cargo build --release
RUN rm -f target/release/deps/rust_on_docker*

COPY . .
RUN cargo build --release

FROM debian:buster-slim
EXPOSE 8000
WORKDIR /app
COPY Rocket.toml .
COPY --from=builder /app/target/release/rust_on_docker .
CMD ["./rust_on_docker"]