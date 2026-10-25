# Setup adapter: runs the pinned upstream Tindra CLI to create the first
# administrator, then exits. The upstream image is distroless (no shell), so
# this wrapper adds a minimal shell runtime for the one-shot bootstrap.
FROM ghcr.io/blendbyte/tindra:1.1.3@sha256:5a3f93d36be20af49748361b07ebd7c24d47980f9d816fe0f5356dc8add81eb9 AS tindra

FROM alpine:3.24@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
COPY --from=tindra /tindra /tindra
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
