
\c test_gis;

SELECT tiger.install_missing_indexes();

VACUUM ANALYZE tiger.addr;
VACUUM ANALYZE tiger.edges;
VACUUM ANALYZE tiger.faces;
VACUUM ANALYZE tiger.featnames;
VACUUM ANALYZE tiger.place;
VACUUM ANALYZE tiger.cousub;
VACUUM ANALYZE tiger.county;
VACUUM ANALYZE tiger.state;
VACUUM ANALYZE tiger.zip_lookup_base;
VACUUM ANALYZE tiger.zip_state;
VACUUM ANALYZE tiger.zip_state_loc;

ANALYZE;