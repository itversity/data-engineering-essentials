-- 1. Get the records that have a count of order date grater than or equal to 120  and descending order by order count and they should be in complete or closed status

SELECT order_date, count(*) AS order_count
FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
HAVING count(*) >= 120
ORDER BY 2 DESC;

-- 2. Typical query execution

-- FROM
-- WHERE
-- GROUP BY
-- SELECT
-- ORDER BY

-- 3. Get the records which have order revenue more than or equal to 2000

SELECT order_item_order_id,
    round(sum(order_item_subtotal)::numeric, 2) AS order_revenue
FROM order_items
GROUP BY 1
HAVING round(sum(order_item_subtotal)::numeric, 2) >= 2000
ORDER BY 2 DESC;