-- Get the number of dead tuples in your tables.
select schemaname,
relname,
pg_size_pretty(pg_relation_size(schemaname|| '.' || relname)) as size,
n_live_tup,
n_dead_tup,
CASE WHEN n_live_tup > 0 THEN round((n_dead_tup::float / 
n_live_tup::float)::numeric, 4) END AS dead_tup_ratio,
last_autovacuum, last_vacuum,
last_autoanalyze, last_analyze
from pg_stat_user_tables 
where schemaname='public'
order by dead_tup_ratio desc NULLS LAST;
