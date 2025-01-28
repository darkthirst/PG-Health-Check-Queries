select invalid.*
 ,u.relname , u.indexrelname , u.idx_scan , u.idx_tup_read , u.idx_tup_fetch
, pg_relation_size(u.indexrelname::regclass) as size
, pg_size_pretty(pg_relation_size(u.indexrelname::regclass)) as pretty_size  
from (
SELECT ind.relname as index_name, indexrelid, tab.relname as table_name, indrelid, pg_get_indexdef(ind.oid)
FROM pg_index i
LEFT JOIN pg_class ind ON i.indexrelid = ind.oid
LEFT JOIN pg_class tab ON i.indrelid = tab.oid
WHERE i.indisvalid=false
)invalid, pg_stat_user_indexes u 
where invalid.index_name = u.indexrelname;
