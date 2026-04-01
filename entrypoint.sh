#!/bin/sh
export PGPASSWORD=$POSTGRES_PASSWORD
if ! psql -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -tAc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DB'" | grep -q 1; then
  createdb -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT $POSTGRES_DB
fi

JDBC_URL="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
case "${POSTGRES_SSL:-false}" in
  true|TRUE|on|ON|1|yes|YES) JDBC_URL="$JDBC_URL?ssl=true&sslmode=require" ;;
esac

flyway -url="$JDBC_URL" -user=$POSTGRES_USER -password=$POSTGRES_PASSWORD -locations=filesystem:/sql -schemas=migrations -placeholderPrefix="##{{" migrate
