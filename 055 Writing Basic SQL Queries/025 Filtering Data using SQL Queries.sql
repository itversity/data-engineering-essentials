-- 1. Taking distinct order status from the order table and ordering by the first column

SELECT DISTINCT order_status FROM orders
ORDER BY 1;

-- 2. Filter orders which is in complete order status

SELECT * FROM orders
WHERE order_status = 'COMPLETE';

-- 3. Filter orders which is in closed order status
 
SELECT * FROM orders
WHERE order_status = 'CLOSED';

-- 4. Filter orders which is in closed or complete order status

SELECT * FROM orders
WHERE order_status = 'CLOSED' OR order_status = 'COMPLETE';

-- 5. Filter the orders which is in closed or complete by using IN operator

SELECT * FROM orders
WHERE order_status IN ('CLOSED', 'COMPLETE');