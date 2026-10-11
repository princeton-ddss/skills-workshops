

-- See https://duckdb.org/docs/data/csv/overview.html for import options; more next time!
CREATE TABLE results AS
  SELECT *
  FROM read_csv('data/countypres_2000-2024.tab');

SELECT * FROM RESULTS LIMIT 3;

-- CLI viewer options:

FROM results LIMIT 1; -- can't see it!

.columns
FROM results LIMIT 1; -- too much!
.rows


/***
 WINDOWS
 what were the top two trump counties in each state, in 2016 (and return the order)?
***/

SELECT county_fips, state, county_name, state_rank
  FROM (
   SELECT *, row_number() OVER (PARTITION BY state ORDER BY candidatevotes/totalvotes DESC) AS state_rank 
     FROM results
     WHERE year = 2016 AND party = 'REPUBLICAN'
    )
WHERE state_rank <= 2;

/***
what are the ten largest counties with the largest shift toward Republicans 2016 -> 2020?
(use joins -- don't worry about pivots)
***/

SELECT
  c1.state, c1.state_po, c1.county_name,
  100 * (c2.candidatevotes/c2.totalvotes - c1.candidatevotes/c1.totalvotes) AS r_shift
FROM (
  FROM results
  WHERE year = 2016
    AND party = 'REPUBLICAN'
  ) c1
INNER JOIN (
  FROM results
  WHERE year = 2024
  AND party = 'REPUBLICAN'
  ) c2
ON c1.county_fips = c2.county_fips
ORDER BY r_shift DESC
LIMIT 10;

-- SPATIAL DATA LOADING AND JOINS:

INSTALL spatial;
LOAD spatial;

SELECT * FROM ST_Drivers(); 

CREATE TABLE counties AS
  SELECT *
  FROM ST_Read('/vsizip/data/cb_2018_us_county_20m.zip/cb_2018_us_county_20m.shx');

-- DROP TABLE counties;

/*** Importing selected columns: ***/

-- Overwriting (and joining) results; add spatial data
CREATE OR REPLACE TABLE results AS
  SELECT *
  FROM results l
  INNER JOIN counties r
  ON l.county_fips = r.GEOID;

-- Because nothing is easy:

-- results.county_fips = counties.GEOID::DOUBLE
-- versus....
-- lpad(results.county_fips::TEXT, 5, '0') = counties.GEOID

/***

We can read spatial data into R from duckdb!

```
sf::st_read(
  conn = con,
  query = 'SELECT * REPLACE ST_AsWKB(geom) AS geom FROM results',
  geometry_column = 'geom'
  )
```
