
\c test_gis;

CREATE TABLE random_wy (
    addid serial NOT NULL PRIMARY KEY,
    r_line_one TEXT,
    r_city TEXT,
    r_state TEXT,
    r_zip TEXT
);

\copy random_wy(r_line_one, r_city, r_state, r_zip) FROM 'data/random_wy.csv' DELIMITER ',' CSV HEADER;

ALTER TABLE random_wy ADD COLUMN address_full TEXT DEFAULT NULL;
UPDATE random_wy SET address_full = CONCAT_WS(', ', r_line_one, r_city, r_state, r_zip);

SELECT * FROM random_wy, LATERAL standardize_address('tiger.pagc_lex','tiger.pagc_gaz','tiger.pagc_rules', random_wy.address_full);
SELECT * FROM random_wy, LATERAL pagc_normalize_address(random_wy.address_full);

SELECT
        random_wy.addid,
        ST_X(ST_SnapToGrid(f.geomout, 0.00001)) AS lon,
        ST_Y(ST_SnapToGrid(f.geomout, 0.00001)) AS lat,
        (f).rating
    FROM random_wy, LATERAL geocode(random_wy.address_full, 1) f;
