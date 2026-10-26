-- =====================================================================
-- 01_create_tables.sql
-- Creates the three raw tables. Database: SQLite.
-- The R script R/01_load_data.R runs this file, then loads the CSVs.
-- =====================================================================

DROP VIEW  IF EXISTS orders_enriched;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS people;

-- One row = one product inside one order
CREATE TABLE orders (
    row_id          INTEGER PRIMARY KEY,
    order_id        TEXT    NOT NULL,
    order_date      TEXT    NOT NULL,   -- stored as 'YYYY-MM-DD'
    ship_date       TEXT    NOT NULL,
    ship_mode       TEXT,
    customer_id     TEXT,
    customer_name   TEXT,
    segment         TEXT,
    country_region  TEXT,
    city            TEXT,
    state_province  TEXT,
    postal_code     TEXT,               -- text, not a number (keeps leading zeros)
    region          TEXT,
    product_id      TEXT,
    category        TEXT,
    sub_category    TEXT,
    product_name    TEXT,
    sales           REAL,
    quantity        INTEGER,
    discount        REAL,               -- 0.2 = 20%
    profit          REAL
);

-- Orders that customers sent back
CREATE TABLE returns (
    order_id  TEXT PRIMARY KEY,
    returned  TEXT
);

-- Manager of each region
CREATE TABLE people (
    regional_manager  TEXT,
    region            TEXT PRIMARY KEY
);
