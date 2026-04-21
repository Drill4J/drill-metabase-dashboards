#!/bin/sh
set -eu

export PGPASSWORD="$POSTGRES_PASSWORD"
if ! psql -U "$POSTGRES_USER" -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -tAc "SELECT 1 FROM pg_database WHERE datname = '$METABASE_DB_NAME'" | grep -q 1; then
  createdb -U "$POSTGRES_USER" -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" "$METABASE_DB_NAME"
fi

# Prepend R__0_Data.sql checksum to R__1_Config.sql so Flyway re-runs it when data changes
DATA_CHECKSUM=$(sha256sum /sql/R__0_Data.sql | awk '{print $1}')
{ echo "-- R__0_Data.sql file checksum is $DATA_CHECKSUM"; cat /sql/R__1_Config.sql; } > /sql/R__1_Config.sql.tmp
mv /sql/R__1_Config.sql.tmp /sql/R__1_Config.sql

JDBC_URL="jdbc:postgresql://$POSTGRES_HOST:$POSTGRES_PORT/$METABASE_DB_NAME"
case "${POSTGRES_SSL:-false}" in
  true) JDBC_URL="$JDBC_URL?ssl=true&sslmode=require" ;;
esac

export FLYWAY_URL="$JDBC_URL"
export FLYWAY_USER="$POSTGRES_USER"
export FLYWAY_PASSWORD="$POSTGRES_PASSWORD"
export FLYWAY_LOCATIONS="filesystem:/sql"
export FLYWAY_SCHEMAS="migrations"
export FLYWAY_PLACEHOLDER_PREFIX="##{{"
export FLYWAY_PLACEHOLDER_SUFFIX="}}"
export FLYWAY_PLACEHOLDERS_DRILLDBHOST="$POSTGRES_HOST"
export FLYWAY_PLACEHOLDERS_DRILLDBPORT="$POSTGRES_PORT"
export FLYWAY_PLACEHOLDERS_DRILLDBSSL="$POSTGRES_SSL"
export FLYWAY_PLACEHOLDERS_DRILLDBNAME="$POSTGRES_DB"
export FLYWAY_PLACEHOLDERS_DRILLDBUSER="$POSTGRES_USER"
export FLYWAY_PLACEHOLDERS_DRILLDBPASSWORD="$POSTGRES_PASSWORD"
export FLYWAY_PLACEHOLDERS_DRILLUIBASEURL="$DRILL_UI_BASE_URL"
export FLYWAY_PLACEHOLDERS_METRICSUIBASEURL="$DRILL_METRICS_UI_BASE_URL"

flyway migrate
