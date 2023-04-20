-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * Filtering Data from Spark Metastore Tables
-- MAGIC * Peforming Aggregations on Spark Metastore Tables
-- MAGIC * **Joining Multiple Spark Metastore Tables**
-- MAGIC * Sorting Data in Spark Metastore Tables
-- MAGIC * Creating Tables based on Query Results
-- MAGIC * Inserting Data into Tables based on Query Results
-- MAGIC * Merging Data into Tables based on Query Results

-- COMMAND ----------

-- INNER JOIN
-- OUTER JOIN (LEFT/RIGHT or FULL)

-- SELECT t1.col1, t2.col2
-- FROM table1 AS t1
--   JOIN table2 AS t2
--     ON t1.col1 = t2.col1
--   JOIN table3 AS t3
--     ON t2.col2 = t3.col2

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

SELECT * FROM order_items

-- COMMAND ----------

SELECT * FROM order_items WHERE order_item_order_id = 3

-- COMMAND ----------

SELECT count(*) FROM orders

-- COMMAND ----------

SELECT count(*) FROM order_items

-- COMMAND ----------

SELECT * 
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id

-- COMMAND ----------

SELECT count(*) 
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id

-- COMMAND ----------

SELECT o.*,
  oi.order_item_product_id,
  oi.order_item_quantity,
  oi.order_item_subtotal
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id

-- COMMAND ----------

SELECT count(DISTINCT order_id) FROM orders

-- COMMAND ----------

SELECT count(DISTINCT order_item_order_id) FROM order_items

-- COMMAND ----------

SELECT * FROM orders WHERE order_id = 3

-- COMMAND ----------

SELECT * FROM order_items WHERE order_item_order_id = 3

-- COMMAND ----------

SELECT o.*,
  oi.order_item_product_id,
  oi.order_item_quantity,
  oi.order_item_subtotal
FROM orders AS o
  LEFT OUTER JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
ORDER BY o.order_id

-- COMMAND ----------

SELECT o.*,
  oi.order_item_product_id,
  oi.order_item_quantity,
  oi.order_item_subtotal
FROM order_items AS oi
  RIGHT OUTER JOIN orders AS o
    ON o.order_id = oi.order_item_order_id
ORDER BY o.order_id

-- COMMAND ----------

SELECT count(*)
FROM orders AS o
  LEFT OUTER JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id

-- COMMAND ----------

SELECT count(*)
FROM order_items AS oi
  RIGHT OUTER JOIN orders AS o
    ON o.order_id = oi.order_item_order_id

-- COMMAND ----------

-- Get revenue for each order_id along with details such as order customer id, status, date, etc

SELECT o.*,
  round(sum(order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
GROUP BY o.order_id,
  o.order_date,
  o.order_customer_id,
  o.order_status
ORDER BY 1

-- COMMAND ----------

SELECT o.order_id,
  o.order_date,
  o.order_customer_id,
  o.order_status,
  round(sum(order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3, 4
ORDER BY 1

-- COMMAND ----------

-- Get revenue for each order_id along with details such as order customer id, status, date, etc
-- If order_items does not have item details associated with a given order id, then revenue should be zero

SELECT o.order_id,
  o.order_date,
  o.order_customer_id,
  o.order_status,
  nvl(round(sum(order_item_subtotal), 2), 0) AS order_revenue
FROM orders AS o
  LEFT OUTER JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
GROUP BY 1, 2, 3, 4
ORDER BY 1

-- COMMAND ----------

-- Get revenue for each order_id where orders are placed in 2014 January and the status is either COMPLETE or CLOSED
-- along with details such as order customer id, status, date, etc
-- If order_items does not have item details associated with a given order id, then revenue should be zero

SELECT o.order_id,
  o.order_date,
  o.order_customer_id,
  o.order_status,
  nvl(round(sum(order_item_subtotal), 2), 0) AS order_revenue
FROM orders AS o
  LEFT OUTER JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE date_format(o.order_date, 'yyyyMM') = 201401
  AND o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2, 3, 4
ORDER BY 1

-- COMMAND ----------

-- Get revenue for each order_id where orders are placed in 2014 January and the status is either COMPLETE or CLOSED
-- along with details such as order customer id, status, date, etc
-- If order_items does not have item details associated with a given order id, then revenue should be zero
-- Get only those orders where the revenue is greater than 500

SELECT o.order_id,
  o.order_date,
  o.order_customer_id,
  o.order_status,
  nvl(round(sum(order_item_subtotal), 2), 0) AS order_revenue
FROM orders AS o
  LEFT OUTER JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE date_format(o.order_date, 'yyyyMM') = 201401
  AND o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1, 2, 3, 4
  HAVING order_revenue > 500
ORDER BY 1

-- COMMAND ----------


