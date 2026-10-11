
CREATE DATABASE test_gis;
\c test_gis;

CREATE EXTENSION postgis_tiger_geocoder CASCADE;
CREATE EXTENSION address_standardizer;
CREATE EXTENSION address_standardizer_data_us;
CREATE EXTENSION hstore;

SELECT postgis_extensions_upgrade();

GRANT USAGE ON SCHEMA tiger TO PUBLIC;
GRANT USAGE ON SCHEMA tiger_data TO PUBLIC;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger TO PUBLIC;
GRANT SELECT, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA tiger_data TO PUBLIC;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA tiger TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA tiger_data GRANT SELECT, REFERENCES ON TABLES TO PUBLIC;

/* MODIFY BELOW AS NECESSARY; os = 'sh' | 'windows' */
UPDATE tiger.loader_platform
    SET declare_sect = '
        TMPDIR="${staging_fold}/temp/"
        UNZIPTOOL=unzip
        WGETTOOL="/usr/local/bin/wget"
        export PGBIN=/Applications/Postgres.app/Contents/Versions/16/bin
        export PGPORT=5454
        export PGHOST=
        export PGUSER=postgres
        export PGPASSWORD=
        export PGDATABASE=test_gis
        PSQL=/Applications/Postgres.app/Contents/Versions/latest/bin/psql
        SHP2PGSQL=shp2pgsql
        cd ${staging_fold}
        '
    WHERE os = 'sh';

/* MODIFY BELOW AS NECESSARY: VINTAGE AND STAGING FOLDER */
UPDATE tiger.loader_variables
    SET tiger_year = '2022',
        website_root = 'https://www2.census.gov/geo/tiger/TIGER2022',
        staging_fold = '/Users/ericmm/gisdata/' -- requires temp/ subfolder
    ;

/* IF USING 2022 DATA -- see https://gis.stackexchange.com/questions/473187/postgis-step-in-state-load-loader-load-staged-data-is-producing-more-columns/473204#473204 */
DO
$do$
BEGIN
IF (SELECT tiger_year = 'rd22' FROM tiger.loader_variables) THEN
   UPDATE tiger.loader_lookuptables
   	SET columns_exclude = '{gid,geoid,cpi,suffix1ce,statefp00,statefp10,countyfp00,countyfp10,tractce00,tractce10,blkgrpce00,blkgrpce10,blockce00,blockce10,cousubfp00,submcdfp00,conctyfp00,placefp00,aiannhfp00,aiannhce00,comptyp00,trsubfp00,trsubce00,anrcfp00,elsdlea00,scsdlea00,unsdlea00,uace00,cd108fp,sldust00,sldlst00,vtdst00,zcta5ce00,tazce00,ugace00,puma5ce00,vtdst10,tazce10,uace10,puma5ce10,tazce,uace,vtdst,zcta5ce10,puma5ce,ugace10,pumace10,estatefp,ugace,blockce,pumace20,sdadmlea,uace20}'::text[]
   	WHERE lookup_name = 'faces';
END IF;
END
$do$



