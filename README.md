# Drill4J - Metabase Dashboards

This repository provides dump files of PostgreSQL tables for [Metabase](https://www.metabase.com/) dashboards.
Metabase is employed to display Drill4J metrics.

## License

Drill4J is not affiliated with Metabase. The Metabase components are the subject to their own [license](https://www.metabase.com/license/).

## How to run

1. Clone repository and navigate to downloaded folder
2. Apply migration:
    1. Adjust migration version and credentials in `.env` file
    2. Execute `docker-compose -f docker-compose-metabase-migration.yml up`
    3. This will launch docker container containing migration file. Wait for it to complete
3. Open `http://localhost:8095`
4. Login using credentials from comment in `docker-compose-metabase.yml` file beginning

You should be able to see preconfigured dashboards. These are likely empty. To see the actual data from your application, run [Drill4J Admin Backend](https://github.com/Drill4J/admin) and setup respective agents following the documentation at https://drill4j.github.io/

## How to create a new migration (for developers)

1. Delete all records from the following tables in the source Metabase database:
```sql
DELETE FROM public.view_log;
DELETE FROM public.task_history;
DELETE FROM public.query_execution;
DELETE FROM public.revision;
DELETE FROM public.core_session;
DELETE FROM public.login_history;
DELETE FROM public.query;
DELETE FROM public.metabase_fieldvalues;
DELETE FROM public.user_parameter_value;
```
2. Create a dump file:
```bash
pg_dump -U $POSTGRES_USER -h $POSTGRES_HOST -p $POSTGRES_PORT -d $METABASE_DB_NAME -n public --no-owner --no-privileges --clean --if-exists --extension=citext --inserts -f ./sql/R__0_Data.sql
```
Example for local deployment:
```bash
pg_dump -U postgres -h localhost -p 5432 -d db-metabase -n public --no-owner --no-privileges --clean --if-exists --extension=citext --inserts -f ./sql/R__0_Data.sql
-- password mysecretpassword
```
3. Update the checksum in `sql/R__1_Config.sql`:

   Calculate the SHA256 checksum of the newly generated `R__0_Data.sql` file:

   **Linux / macOS:**
   ```bash
   sha256sum ./sql/R__0_Data.sql
   ```

   **Windows (PowerShell):**
   ```powershell
   (Get-FileHash .\sql\R__0_Data.sql -Algorithm SHA256).Hash.ToLower()
   ```

   Then replace the checksum value of `sql/R__1_Config.sql` after the phrase `-- R__0_Data.sql file checksum is ` with the newly calculated value:
   ```sql
   -- R__0_Data.sql file checksum is <paste-new-checksum-here>
   ```

   > **Note:** The hashing algorithm can be any (MD5, SHA1, SHA256, etc.) - what matters is that the resulting checksum is unique and changes every time `R__0_Data.sql` is regenerated. This is necessary because Flyway does not re-execute a repeatable migration script (`R__*.sql`) unless its own content has changed. By updating the checksum comment, we force Flyway to re-run `R__1_Config.sql` whenever `R__0_Data.sql` is updated.


