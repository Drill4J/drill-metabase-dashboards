FROM flyway/flyway:10.22.0

WORKDIR /sql

COPY ./sql /sql

ENTRYPOINT ["/bin/sh", "-c", "flyway -url=jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB -user=$POSTGRES_USER -password=$POSTGRES_PASSWORD -locations=filesystem:/sql -schemas=migrations -placeholderPrefix=\"##{{\" migrate"]