SELECT relname , n_dead_tup , n_live_tup 
  , trunc(1.0*n_dead_tup/(n_live_tup+1), 2)::float as ratio 
  , autovacuum_count , (now() - last_autovacuum) as since_last_autovacuum 
  , autoanalyze_count , n_mod_since_analyze 
  , (now() - last_autoanalyze) as since_last_autoanalyze 
  , n_tup_ins , n_tup_upd , n_tup_del , n_tup_hot_upd 
FROM pg_stat_user_tables WHERE n_dead_tup > 0 
ORDER BY n_live_tup desc; 
SELECT s.schemaname, 
       s.relname AS tablename, 
       s.indexrelname AS indexname, 
       pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size, 
       s.idx_scan AS index_scan_count, s.idx_tup_read, s.idx_tup_fetch 
FROM pg_catalog.pg_stat_user_indexes s 
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid 
--    JOIN pg_indexes iis ON iis.indexname = s.indexrelname 
WHERE 0 <>ALL (i.indkey)  -- no index column is an expression 
  AND NOT i.indisunique   -- is not a UNIQUE index 
  AND NOT EXISTS          -- does not enforce a constraint 
         (SELECT 1 FROM pg_catalog.pg_constraint c 
          WHERE c.conindid = s.indexrelid) 
--   AND iis.tablespace IS NULL 
ORDER BY pg_relation_size(s.indexrelid) DESC; 
