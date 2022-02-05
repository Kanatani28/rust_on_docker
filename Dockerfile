FROM rust:1.58.1 as builder
WORKDIR /app
COPY . .
RUN rustup default nightly
RUN cargo build --release


FROM debian:buster-slim
COPY --from=builder /app/target/release/rust_on_docker .
CMD ["./rust_on_docker"]