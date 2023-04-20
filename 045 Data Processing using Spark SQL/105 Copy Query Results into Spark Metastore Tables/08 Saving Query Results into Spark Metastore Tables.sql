-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * Filtering Data from Spark Metastore Tables
-- MAGIC * Peforming Aggregations on Spark Metastore Tables
-- MAGIC * Joining Multiple Spark Metastore Tables
-- MAGIC * Sorting Data in Spark Metastore Tables
-- MAGIC * **Creating Tables based on Query Results**
-- MAGIC * **Inserting Data into Tables based on Query Results**
-- MAGIC * **Merging Data into Tables based on Query Results**

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

SHOW tables

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

SELECT * FROM order_items

-- COMMAND ----------

SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date
ORDER BY o.order_date

-- COMMAND ----------

-- CTAS
-- CREATE TABLE IF NOT EXISTS table_name
-- AS
-- SELECT col1, col2 FROM table1

-- COMMAND ----------

SHOW tables

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS daily_revenue
AS
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date

-- COMMAND ----------

SHOW tables

-- COMMAND ----------

DESCRIBE FORMATTED daily_revenue

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

DROP TABLE daily_revenue

-- COMMAND ----------

CREATE TABLE daily_revenue (
  order_date DATE,
  order_revenue FLOAT
)

-- COMMAND ----------

INSERT INTO daily_revenue
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

INSERT OVERWRITE daily_revenue
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
GROUP BY o.order_date

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

-- main tables -> stage table (DROP and CREATE using CTAS or INSERT OVERWRITE) -> Final Reporting Table (INSERT INTO)

-- COMMAND ----------

CREATE TABLE daily_revenue_stg (
  order_date DATE,
  order_revenue FLOAT
)

-- COMMAND ----------

SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
  AND date_format(o.order_date, 'yyyyMM') = 201307
GROUP BY o.order_date
ORDER BY o.order_date

-- COMMAND ----------

INSERT OVERWRITE daily_revenue_stg
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
  AND date_format(o.order_date, 'yyyyMM') = 201307
GROUP BY o.order_date

-- COMMAND ----------

INSERT INTO daily_revenue
SELECT * FROM daily_revenue_stg

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS daily_revenue_stg (
  order_date DATE,
  order_revenue FLOAT
);

INSERT OVERWRITE daily_revenue_stg
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
  AND date_format(o.order_date, 'yyyyMM') = 201308
GROUP BY o.order_date;

INSERT INTO daily_revenue
SELECT * FROM daily_revenue_stg;

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

DROP TABLE IF EXISTS daily_revenue_stg;

CREATE TABLE daily_revenue_stg
AS
SELECT o.order_date,
  round(sum(oi.order_item_subtotal), 2) AS order_revenue
FROM orders AS o
  JOIN order_items AS oi
    ON o.order_id = oi.order_item_order_id
WHERE o.order_status IN ('COMPLETE', 'CLOSED')
  AND date_format(o.order_date, 'yyyyMM') = 201310
GROUP BY o.order_date;

INSERT INTO daily_revenue
SELECT * FROM daily_revenue_stg;

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------

-- MERGE INTO target_table AS t
-- USING source_table AS s
--   ON t.col1 = s.col1
-- WHEN MATCHING THEN UPDATE SET *
-- WHEN NOT MATCHING THEN INSERT *

-- COMMAND ----------

TRUNCATE TABLE daily_revenue

-- COMMAND ----------

MERGE INTO daily_revenue AS t
USING (
  SELECT o.order_date,
    round(sum(oi.order_item_subtotal), 2) AS order_revenue
  FROM orders AS o
    JOIN order_items AS oi
      ON o.order_id = oi.order_item_order_id
  WHERE o.order_status IN ('COMPLETE', 'CLOSED')
    AND o.order_date BETWEEN '2013-08-01' AND '2013-10-31'
  GROUP BY o.order_date
) AS s
ON s.order_date = t.order_date
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *

-- COMMAND ----------

SELECT * FROM daily_revenue
ORDER BY order_date

-- COMMAND ----------


