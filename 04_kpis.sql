-- =====================================================================
-- 04_kpis.sql
-- The four KPI cards of the dashboard (+ two extra KPIs).
-- Golden rule: for a ratio, add up first, then divide.
--   correct: SUM(profit) / SUM(sales)
--   wrong:   SUM(profit_margin)  or  AVG(profit_margin)
-- =====================================================================

SELECT
    ROUND(SUM(sales), 0)                                   AS total_sales,      -- 2,326,534
    ROUND(SUM(profit), 0)                                  AS total_profit,     -- 292,297
    ROUND(100.0 * SUM(profit) / SUM(sales), 1)             AS profit_margin_pct,-- 12.6
    COUNT(DISTINCT order_id)                               AS orders,           -- 5,111
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 0)        AS sales_per_order,  -- 455
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN order_id END)
                / COUNT(DISTINCT order_id), 1)             AS return_rate_pct,  -- 5.8
    ROUND(100.0 * SUM(profit < 0) / COUNT(*), 1)           AS loss_lines_pct    -- 18.6
FROM orders_enriched;
