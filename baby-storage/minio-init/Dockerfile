# The Chainguard mc image has no shell, so copy its static binary into a pinned Alpine base
# to run the multi-step bucket bootstrap script.
FROM chainguard/minio-client@sha256:d8a93c5d335509ff353774eefec8f82fa2a2a975e800139702232d8be3dbe6b9 AS mc

FROM alpine:3.24.2
COPY --from=mc /usr/bin/mc /usr/local/bin/mc
COPY init-buckets.sh /usr/local/bin/init-buckets.sh
RUN chmod 0555 /usr/local/bin/init-buckets.sh && adduser -D -u 10001 init
USER init
ENTRYPOINT ["/usr/local/bin/init-buckets.sh"]
