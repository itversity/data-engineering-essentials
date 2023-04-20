-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * Filtering Data from Spark Metastore Tables
-- MAGIC * **Peforming Aggregations on Spark Metastore Tables**
-- MAGIC * Joining Multiple Spark Metastore Tables
-- MAGIC * Sorting Data in Spark Metastore Tables
-- MAGIC * Creating Tables based on Query Results
-- MAGIC * Inserting Data into Tables based on Query Results
-- MAGIC * Merging Data into Tables based on Query Results

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

SHOW tables

-- COMMAND ----------

SELECT count(*) FROM orders

-- COMMAND ----------

SELECT count(*) FROM order_items

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

SELECT count(*) FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')

-- COMMAND ----------

SELECT count(DISTINCT order_customer_id) FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')

-- COMMAND ----------

SELECT * FROM order_items

-- COMMAND ----------

SELECT round(sum(order_item_subtotal), 2) AS order_revenue
FROM order_items
WHERE order_item_order_id = 2

-- COMMAND ----------

SELECT round(sum(order_item_subtotal), 2) AS order_revenue,
  round(avg(order_item_subtotal), 2) AS avg_order_revenue
FROM order_items
WHERE order_item_order_id = 2

-- COMMAND ----------

-- SELECT group_key,
--   aggregate_functions -- count, sum, avg, min, max
-- FROM table_name
-- WHERE conditions_to_filter_the_data
-- GROUP BY 1
-- ORDER BY 1

SELECT order_status,
  count(*) AS order_count
FROM orders
GROUP BY 1

-- COMMAND ----------

SELECT order_item_order_id
FROM order_items
GROUP BY order_item_order_id

-- COMMAND ----------

SELECT order_item_order_id,
  round(sum(order_item_subtotal), 2) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
ORDER BY order_item_order_id

-- COMMAND ----------

SELECT order_date,
  count(*) AS order_count
FROM orders
WHERE date_format(order_date, 'yyyyMM') = 201401
  AND order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
ORDER BY 1

-- COMMAND ----------

-- SELECT 
-- FROM
-- WHERE
-- GROUP BY
-- ORDER BY

-- FROM
-- WHERE
-- GROUP BY
-- SELECT
-- ORDER BY

SELECT order_date,
  count(*) AS order_count
FROM orders
WHERE date_format(order_date, 'yyyyMM') = 201401
  AND order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
ORDER BY order_count DESC

-- COMMAND ----------

SELECT * FROM (
  SELECT order_date,
    count(*) AS order_count
  FROM orders
  WHERE date_format(order_date, 'yyyyMM') = 201401
    AND order_status IN ('COMPLETE', 'CLOSED')
  GROUP BY 1
) WHERE order_count > 100
ORDER BY 2 DESC
-- Verbose
-- Performance Issues

-- COMMAND ----------

SELECT order_date,
  count(*) AS order_count
FROM orders
WHERE date_format(order_date, 'yyyyMM') = 201401
  AND order_status IN ('COMPLETE', 'CLOSED')
GROUP BY 1
  HAVING count(*) > 100
ORDER BY 2 DESC

-- COMMAND ----------

SELECT order_item_order_id,
  round(sum(order_item_subtotal), 2) AS order_revenue
FROM order_items
GROUP BY order_item_order_id
  HAVING order_revenue > 1000
ORDER BY 1

-- COMMAND ----------


