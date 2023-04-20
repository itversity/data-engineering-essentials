-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * **Filtering Data from Spark Metastore Tables**
-- MAGIC * Peforming Aggregations on Spark Metastore Tables
-- MAGIC * Joining Multiple Spark Metastore Tables
-- MAGIC * Sorting Data in Spark Metastore Tables
-- MAGIC * Creating Tables based on Query Results
-- MAGIC * Inserting Data into Tables based on Query Results
-- MAGIC * Merging Data into Tables based on Query Results

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

SELECT DISTINCT order_status FROM orders

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_status = 'ON_HOLD'

-- COMMAND ----------

-- SELECT *
-- FROM orders
-- WHERE order_status = 'COMPLETE' OR order_status = 'CLOSED'

SELECT *
FROM orders
WHERE order_status IN ('COMPLETE', 'CLOSED')

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_status NOT IN ('COMPLETE', 'CLOSED')

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_status LIKE 'PENDING%'

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_status NOT LIKE 'PENDING%'

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_status LIKE '%PAY%'

-- COMMAND ----------

SELECT *
FROM orders
WHERE order_date BETWEEN '2014-01-15' AND '2014-01-22'

-- COMMAND ----------

SELECT DISTINCT order_date
FROM orders
WHERE order_date BETWEEN '2014-01-15' AND '2014-01-22'
ORDER BY 1

-- COMMAND ----------

-- order date = 2014 Jan 1st, then order status should be either COMPLETE or CLOSED
SELECT * FROM orders
WHERE order_date = '2014-01-01'
  AND (order_status = 'COMPLETE' OR order_status = 'CLOSED')

-- COMMAND ----------

SELECT * FROM orders
WHERE order_date = '2014-01-01'
  AND order_status IN ('COMPLETE', 'CLOSED')

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phone STRING,
  user_email STRING
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', '1234567890', 'stiger@email.com'),
  (2, 'Donald', 'Duck', NULL, 'dduck@email.com'),
  (3, 'Mickey', 'Mouse', NULL, NULL),
  (4, 'Minnie', 'Mouse', '2345678012', NULL)

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

SELECT * FROM users
WHERE user_phone IS NULL OR user_email IS NULL

-- COMMAND ----------

SELECT * FROM users
WHERE user_phone IS NULL AND user_email IS NULL

-- COMMAND ----------

SELECT NULL IS NOT NULL

-- COMMAND ----------


