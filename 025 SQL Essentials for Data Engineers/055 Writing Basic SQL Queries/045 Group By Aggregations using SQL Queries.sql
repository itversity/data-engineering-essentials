SELECT * FROM orders;

-- 1. Get the count for each order status and count should be in descending order

SELECT order_status, count(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 2. Get the count for each order date and count should be in descending order

SELECT order_date, count(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Get the count for each order month (derived column) and count should be in descending order

SELECT to_char(order_date, 'yyyy-MM') AS order_month, count(*) AS order_count
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 4. Get all the columns in order items table

SELECT * FROM order_items;

-- 5. Get the order revenue for each order id

SELECT order_item_order_id, 
    round(sum(order_item_subtotal)::numeric, 2) AS order_revenue
FROM order_items
GROUP BY 1
ORDER BY 1;