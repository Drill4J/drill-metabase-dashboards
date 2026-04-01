-- This SQL file is used to configure the Drill4J Connection in Metabase.
-- R__0_Data.sql file checksum is 40b657bbd4ab3d8a5f6e6d7464f1fb867fe8529b6563e43b7f5ced6fac92f617
UPDATE public.metabase_database SET details = '{"ssl":##{{drillDBSSL}},"password":"##{{drillDBPassword}}","port":##{{drillDBPort}},"advanced-options":false,"schema-filters-type":"all","dbname":"##{{drillDBName}}","host":"##{{drillDBHost}}","tunnel-enabled":false,"user":"##{{drillDBUser}}"}' WHERE name = 'Drill4J_PostgreSQL_DB';
UPDATE public.setting SET value = '##{{metabaseBaseUrl}}' WHERE key = 'site-url';
UPDATE public.report_dashboard
SET parameters = (
    SELECT jsonb_agg(
        CASE
            WHEN elem->>'name' = 'DRILL UI URL'
            THEN jsonb_set(
                    elem,
                    '{default}',
                    ('["' || replace(replace('##{{drillUIBaseUrl}}', 'https://', ''), 'http://', '') || '"]')::jsonb
                 )
            ELSE elem
        END
    )::text
    FROM jsonb_array_elements(parameters::jsonb) AS elem
)
WHERE parameters IS NOT NULL
  AND parameters::jsonb @> '[{"name": "DRILL UI URL"}]';

UPDATE public.setting
SET value = value || ',' || chr(10) || replace(replace('##{{drillUIBaseUrl}}', 'https://', ''), 'http://', '')
WHERE key = 'allowed-iframe-hosts'
  AND value NOT LIKE '%' || replace(replace('##{{drillUIBaseUrl}}', 'https://', ''), 'http://', '') || '%';