-- =====================================================================
-- 05_analysis.sql
-- One query per dashboard chart, plus the "why" questions.
-- Each query starts with a comment that names the chart it feeds.
-- =====================================================================

-- Q1. Sales & profit by year  (growth story)
SELECT order_year,
       ROUND(SUM(sales), 0)                       AS sales,
       ROUND(SUM(profit), 0)                      AS profit,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_enriched
GROUP BY order_year
ORDER BY order_year;

-- Q2. Sales & profit by month  (chart: Sales & Profit Trend)
SELECT order_month,
       ROUND(SUM(sales), 0)  AS sales,
       ROUND(SUM(profit), 0) AS profit
FROM orders_enriched
GROUP BY order_month
ORDER BY order_month;

-- Q3. Profit by sub-category  (chart: Profit by Sub-Category)
SELECT category,
       sub_category,
       ROUND(SUM(sales), 0)                       AS sales,
       ROUND(SUM(profit), 0)                      AS profit,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct,
       CASE WHEN SUM(profit) >= 0 THEN 'Profit' ELSE 'Loss' END AS profit_or_loss
FROM orders_enriched
GROUP BY category, sub_category
ORDER BY profit DESC;

-- Q4. Profit by discount band  (chart: Discount vs Profit)
SELECT discount_band,
       COUNT(*)                                   AS order_lines,
       ROUND(SUM(sales), 0)                       AS sales,
       ROUND(SUM(profit), 0)                      AS profit,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_enriched
GROUP BY discount_band
ORDER BY CASE discount_band
             WHEN 'None'            THEN 1
             WHEN 'Low (1-20%)'     THEN 2
             WHEN 'Medium (21-40%)' THEN 3
             ELSE 4
         END;

-- Q5. Profit by state / province  (chart: Profit Map)
SELECT country_region,
       state_province,
       ROUND(SUM(sales), 0)                       AS sales,
       ROUND(SUM(profit), 0)                      AS profit,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_enriched
GROUP BY country_region, state_province
ORDER BY profit;

-- Q6. Margin by region x segment  (chart: Region & Segment heat map)
SELECT region,
       segment,
       ROUND(100.0 * SUM(profit) / SUM(sales), 1) AS margin_pct
FROM orders_enriched
GROUP BY region, segment
ORDER BY region, segment;

-- Q7. WHY does Texas lose money?  Texas vs California vs New York discounts
SELECT state_province,
       ROUND(100.0 * AVG(discount), 1)                         AS avg_discount_pct,
       ROUND(100.0 * SUM(discount = 0) / COUNT(*), 1)          AS pct_lines_no_discount,
       ROUND(SUM(profit), 0)                                   AS profit
FROM orders_enriched
WHERE state_province IN ('Texas', 'California', 'New York')
GROUP BY state_province
ORDER BY profit;

-- Q8. Top 10 loss-making products
SELECT product_name,
       sub_category,
       ROUND(SUM(sales), 0)  AS sales,
       ROUND(SUM(profit), 0) AS profit
FROM orders_enriched
GROUP BY product_name, sub_category
ORDER BY profit
LIMIT 10;

-- Q9. Returns by region (which managers have the most returns?)
SELECT region,
       regional_manager,
       COUNT(DISTINCT order_id)                                        AS orders,
       COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN order_id END)    AS returned_orders,
       ROUND(100.0 * COUNT(DISTINCT CASE WHEN returned = 'Yes' THEN order_id END)
                   / COUNT(DISTINCT order_id), 1)                      AS return_rate_pct
FROM orders_enriched
GROUP BY region, regional_manager
ORDER BY return_rate_pct DESC;
