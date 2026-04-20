-- This SQL file is used to configure the Drill4J Connection in Metabase.
UPDATE public.metabase_database SET details = '{"ssl":##{{drillDBSSL}},"password":"##{{drillDBPassword}}","port":##{{drillDBPort}},"advanced-options":false,"schema-filters-type":"all","dbname":"##{{drillDBName}}","host":"##{{drillDBHost}}","tunnel-enabled":false,"user":"##{{drillDBUser}}"}' WHERE name = 'Drill4J_PostgreSQL_DB';
UPDATE public.setting SET value = '##{{metabaseBaseURL}}' WHERE key = 'site-url';

UPDATE public.setting
SET value = value || ',' || chr(10) || replace(replace('##{{drillUIBaseURL}}', 'https://', ''), 'http://', '')
WHERE key = 'allowed-iframe-hosts'
  AND value NOT LIKE '%' || replace(replace('##{{drillUIBaseURL}}', 'https://', ''), 'http://', '') || '%';

UPDATE public.report_dashboardcard
SET visualization_settings = regexp_replace(
    visualization_settings,
    '"iframe":"<iframe src=\\"[^"]*?/iframe/',
    '"iframe":"<iframe src=\\"##{{drillUIBaseURL}}/iframe/',
    'g'
)
WHERE visualization_settings LIKE '%<iframe src=\"%/iframe/%';
