-- 1. OUTER JOIN - Get all the records which satisfy join condition
-- and also those records which present in orders but not in order_items
-- order_items fields will have null values
SELECT o.order_id, o.order_date,
    oi.order_item_id ,
    oi.order_item_product_id,
    oi.order_item_subtotal
FROM orders AS o
    LEFT OUTER JOIN order_items AS oi
        ON o.order_id = oi.order_item_order_id
ORDER BY 1;