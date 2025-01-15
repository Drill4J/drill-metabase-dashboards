FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh
COPY data.sql data.sql

ENTRYPOINT ["./entrypoint.sh", "data.sql"]
