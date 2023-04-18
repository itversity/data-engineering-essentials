-- Use both PARTITION BY as well as ORDER BY
-- PARTITION BY should have the key based on which data is supposed to be grouped
-- ORDER BY should have the keys based on which data is supposed to be sorted to compute ranks
-- We might have consider DESC under ORDER BY in most of the scenarios
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
ORDER BY order_date, order_revenue DESC;