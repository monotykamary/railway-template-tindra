# Setup adapter: runs the pinned upstream Tindra CLI to create the first
# administrator, then exits. The upstream image is distroless (no shell), so
# this wrapper adds a minimal shell runtime for the one-shot bootstrap.
FROM ghcr.io/blendbyte/tindra:0.6.4 AS tindra

FROM alpine:3.21@sha256:48b0309ca019d89d40f670aa1bc06e426dc0931948452e8491e3d65087abc07d
COPY --from=tindra /tindra /tindra
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
