-- =====================================================================
-- 02_create_view.sql
-- The SQL version of the 7 Excel helper columns.
-- A VIEW is a saved query: it behaves like a table but stores no data.
-- =====================================================================

DROP VIEW IF EXISTS orders_enriched;

CREATE VIEW orders_enriched AS
SELECT
    o.*,

    -- Excel: =YEAR(C2)
    CAST(strftime('%Y', o.order_date) AS INTEGER)            AS order_year,

    -- Excel: =DATE(YEAR(C2),MONTH(C2),1)
    strftime('%Y-%m-01', o.order_date)                       AS order_month,

    -- Excel: =D2-C2
    CAST(julianday(o.ship_date) - julianday(o.order_date) AS INTEGER) AS ship_days,

    -- Excel: =IF(R2=0,0,U2/R2)   (row level only - never SUM or AVG this!)
    CASE WHEN o.sales = 0 THEN 0 ELSE o.profit / o.sales END AS profit_margin,

    -- Excel: nested IF  /  Tableau: IF ... ELSEIF ... END
    CASE
        WHEN o.discount = 0    THEN 'None'
        WHEN o.discount <= 0.2 THEN 'Low (1-20%)'
        WHEN o.discount <= 0.4 THEN 'Medium (21-40%)'
        ELSE                        'High (41-80%)'
    END                                                      AS discount_band,

    -- Excel: IF(ISNUMBER(MATCH(...)))  ->  SQL: LEFT JOIN
    CASE WHEN r.order_id IS NOT NULL THEN 'Yes' ELSE 'No' END AS returned,

    -- Excel: INDEX/MATCH  ->  SQL: LEFT JOIN
    p.regional_manager

FROM orders o
LEFT JOIN returns r ON r.order_id = o.order_id
LEFT JOIN people  p ON p.region   = o.region;
