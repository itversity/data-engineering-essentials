-- Filtering based on Global Ranks using Nested Queries and CTEs in SQL

-- Using Nested Query
SELECT * FROM (
    SELECT order_date,
        order_item_product_id,
        order_revenue,
        rank() OVER (ORDER BY order_revenue DESC) AS rnk,
        dense_rank() OVER (ORDER BY order_revenue DESC) AS drnk
    FROM daily_product_revenue
    WHERE order_date = '2014-01-01 00:00:00.0'
) AS q
WHERE drnk <= 5
ORDER BY order_revenue DESC;

-- Using Common Table Expressions or CTEs
WITH daily_product_revenue_ranks AS (
    SELECT order_date,
        order_item_product_id,
        order_revenue,
        rank() OVER (ORDER BY order_revenue DESC) AS rnk,
        dense_rank() OVER (ORDER BY order_revenue DESC) AS drnk
    FROM daily_product_revenue
    WHERE order_date = '2014-01-01 00:00:00.0'
) SELECT * FROM daily_product_revenue_ranks
WHERE drnk <= 5
ORDER BY order_revenue DESC;