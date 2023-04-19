-- 1. INNER JOIN - Get all the records from both datasets which satisfy the JOIN condition.

SELECT o.order_date,
    oi.order_item_product_id,
    oi.order_item_subtotal
FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id;