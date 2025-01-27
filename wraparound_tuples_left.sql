SELECT oid::regclass::text AS table, --relfrozenxid, 
      age(relfrozenxid), 
      mxid_age(relminmxid), 
       least( 
           (SELECT setting::int 
            FROM    pg_settings 
            WHERE   name = 'autovacuum_freeze_max_age') - age(relfrozenxid), 
           (SELECT setting::int 
            FROM    pg_settings 
            WHERE   name = 'autovacuum_multixact_freeze_max_age') - mxid_age(relminmxid) 
        ) AS tx_before_wraparound_vacuum, 
pg_size_pretty(pg_total_relation_size(oid)) AS size 
FROM    pg_class 
WHERE   relfrozenxid != 0 
AND oid > 16384 
ORDER BY tx_before_wraparound_vacuum; 
