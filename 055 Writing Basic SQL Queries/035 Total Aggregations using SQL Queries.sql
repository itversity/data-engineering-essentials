-- 1. Get all number of orders

SELECT count(*) FROM orders;

-- 2. Get all number of order items

SELECT count(*) FROM order_items;

-- 3. Get all the number of distinct order status from orders table

SELECT count(DISTINCT order_status) FROM  orders;

-- 4. Get all the number of distinct order dates from orders table

SELECT count(DISTINCT order_date) FROM orders;

-- 5. Get all columns from order item table

SELECT * FROM order_items; 

-- 6. Get sum of order item subtotal for given order id

SELECT sum(order_item_subtotal) 
FROM order_items
WHERE order_item_order_id = 2;