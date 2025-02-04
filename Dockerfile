FROM flyway/flyway:10.22.0

RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY createdb.sh createdb.sh
RUN chmod +x createdb.sh

COPY ./sql /sql

ENTRYPOINT ["./entrypoint.sh"]