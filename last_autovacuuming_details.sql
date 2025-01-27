SELECT relname , n_dead_tup , n_live_tup 
  , trunc(1.0*n_dead_tup/(n_live_tup+1), 2)::float as ratio 
  , autovacuum_count , (now() - last_autovacuum) as since_last_autovacuum 
  , autoanalyze_count , n_mod_since_analyze 
  , (now() - last_autoanalyze) as since_last_autoanalyze 
  , n_tup_ins , n_tup_upd , n_tup_del , n_tup_hot_upd 
FROM pg_stat_user_tables WHERE n_dead_tup > 0 
ORDER BY n_live_tup desc; 
