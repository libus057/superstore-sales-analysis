-- =====================================================================
-- 03_data_quality.sql
-- Check the data before analysing it (same checks as the Excel lesson).
-- =====================================================================

-- 1. How many rows? (expected: 10,194)
SELECT COUNT(*) AS total_rows
FROM orders;

-- 2. Missing values in the key columns (expected: all 0)
SELECT
    SUM(order_id   IS NULL) AS missing_order_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(sales      IS NULL) AS missing_sales,
    SUM(profit     IS NULL) AS missing_profit,
    SUM(region     IS NULL) AS missing_region
FROM orders;

-- 3. Possible duplicates: the same order + product + values twice
--    Result: 2 pairs (Row IDs 391/392 and 1699/1700).
--    Excel's "Remove Duplicates" on ALL columns found none, because the Row IDs differ.
--    Impact is tiny ($380 of sales), so they are kept and documented, not deleted.
SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT order_id, product_id, sales, quantity, discount, profit, COUNT(*) AS n
    FROM orders
    GROUP BY order_id, product_id, sales, quantity, discount, profit
    HAVING COUNT(*) > 1
);

-- 4. Date range (expected: 2023-01-03 to 2026-12-30)
SELECT MIN(order_date) AS first_order,
       MAX(order_date) AS last_order
FROM orders;

-- 5. Impossible values (expected: 0)
SELECT
    SUM(sales <= 0)                   AS non_positive_sales,
    SUM(quantity <= 0)                AS non_positive_quantity,
    SUM(discount < 0 OR discount > 1) AS bad_discount,
    SUM(ship_date < order_date)       AS shipped_before_ordered
FROM orders;

-- 6. Countries in the data (United States + Canada)
SELECT country_region, COUNT(*) AS order_lines, ROUND(SUM(sales), 0) AS sales
FROM orders
GROUP BY country_region;
