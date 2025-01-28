SELECT s.schemaname, 
       s.relname AS tablename, 
       s.indexrelname AS indexname, 
       pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size, 
       s.idx_scan AS index_scan_count, 
       s.idx_tup_read, s.idx_tup_fetch
FROM pg_catalog.pg_stat_user_indexes s 
   JOIN pg_catalog.pg_index i ON s.indexrelid = i.indexrelid 
--    JOIN pg_indexes iis ON iis.indexname = s.indexrelname 
WHERE 0 <>ALL (i.indkey)  -- no index column is an expression 
  AND NOT i.indisunique   -- is not a UNIQUE index 
  AND NOT EXISTS          -- does not enforce a constraint 
         (SELECT 1 FROM pg_catalog.pg_constraint c 
          WHERE c.conindid = s.indexrelid) 
--   AND iis.tablespace IS NULL 
ORDER BY index_scan_count ASC; 
