-- Filtering based on Ranks with in each key using Nested Queries and CTEs in SQL

-- Using Common Table Expressions or CTEs
WITH daily_product_revenue_ranks AS (
    SELECT order_date,
        order_item_product_id,
        order_revenue,
        rank() OVER (
            PARTITION BY order_date
            ORDER BY order_revenue DESC
        ) AS rnk,
        dense_rank() OVER (
            PARTITION BY order_date
            ORDER BY order_revenue DESC
        ) AS drnk
    FROM daily_product_revenue
    WHERE to_char(order_date::date, 'yyyy-MM') = '2014-01'
) SELECT * FROM daily_product_revenue_ranks
WHERE drnk <= 5
ORDER BY order_date, order_revenue DESC;