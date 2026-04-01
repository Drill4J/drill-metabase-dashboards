#!/bin/sh
set -eu

export PGPASSWORD="$POSTGRES_PASSWORD"
if ! psql -U "$POSTGRES_USER" -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -tAc "SELECT 1 FROM pg_database WHERE datname = '$METABASE_DB_NAME'" | grep -q 1; then
  createdb -U "$POSTGRES_USER" -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" "$METABASE_DB_NAME"
fi

JDBC_URL="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$METABASE_DB_NAME"
case "${POSTGRES_SSL:-false}" in
  true) JDBC_URL="$JDBC_URL?ssl=true&sslmode=require" ;;
esac

flyway \
  -url="$JDBC_URL" \
  -user="$POSTGRES_USER" \
  -password="$POSTGRES_PASSWORD" \
  -locations="filesystem:/sql" \
  -schemas="migrations" \
  -placeholderPrefix="##{{" \
  -placeholderSuffix="}}" \
  -placeholders.drillDBHost="$POSTGRES_HOST" \
  -placeholders.drillDBPort="$POSTGRES_PORT" \
  -placeholders.drillDBSSL="$POSTGRES_SSL" \
  -placeholders.drillDBName="$DRILL_DB_NAME" \
  -placeholders.drillDBUser="$POSTGRES_USER" \
  -placeholders.drillDBPassword="$POSTGRES_PASSWORD" \
  -placeholders.drillUIBaseURL="$DRILL_UI_BASE_URL" \
  -placeholders.metabaseBaseURL="$METABASE_BASE_URL" \
  migrate
