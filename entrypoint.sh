#!/bin/sh
export PGPASSWORD=$POSTGRES_PASSWORD
if ! psql -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -tAc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1; then
  createdb -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT $POSTGRES_DB
fi

flyway -url=jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB -user=$POSTGRES_USER -password=$POSTGRES_PASSWORD -locations=filesystem:/sql -schemas=migrations -placeholderPrefix="##{{" migrate
