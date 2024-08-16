# Drill4J - Metabase Dashboards

This repository contains dump files of PostgreSQL tables for [Metabase](https://www.metabase.com/) dashboards.
Metabase is employed to display Drill4J metrics.

## License

Drill4J is not affiliated with Metabase. The Metabase components are the subject to their own [license](https://www.metabase.com/license/).

## How to run
1. Copy [./docker-compose-metabase.yml](./docker-compose-metabase.yml)
2. Download `.sql` dump file from the latest release https://github.com/Drill4J/drill-metabase-dashboards/releases
```
 -/
 -/docker-compose-metabase.yml
 -/metabase-volumes/pg
 -/metabase-volumes/data.sql
```
5. Run `docker-compose -f docker-compose-metabase.yml up -d` 
6. Open `http://localhost:8095`
7. Login using credentials from comment in `docker-compose-metabase.yml` file beginning

You should be able to see preconfigured dashboards. These are likely empty. To see the actual data from your application, run [Drill4J Admin Backend](https://github.com/Drill4J/admin) and setup respective agents following the documentation at https://drill4j.github.io/

