-- To compute global ranks use ORDER BY only
SELECT order_date,
    order_item_product_id,
    order_revenue,
    rank() OVER (ORDER BY order_revenue DESC) AS rnk,
    dense_rank() OVER (ORDER BY order_revenue DESC) AS drnk
FROM daily_product_revenue
WHERE order_date = '2014-01-01 00:00:00.0'
ORDER BY order_revenue DESC;