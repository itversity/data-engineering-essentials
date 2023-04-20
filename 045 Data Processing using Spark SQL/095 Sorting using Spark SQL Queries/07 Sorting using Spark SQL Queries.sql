-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * Filtering Data from Spark Metastore Tables
-- MAGIC * Peforming Aggregations on Spark Metastore Tables
-- MAGIC * Joining Multiple Spark Metastore Tables
-- MAGIC * **Sorting Data in Spark Metastore Tables**
-- MAGIC * Creating Tables based on Query Results
-- MAGIC * Inserting Data into Tables based on Query Results
-- MAGIC * Merging Data into Tables based on Query Results

-- COMMAND ----------

-- Based on 1 column
-- Based on multiple columns (composite sorting)
-- Ascending or Descending
-- Dealing with Nulls

-- SELECT col1, col2
-- FROM table1
-- ORDER BY col1 ASC, col2 DESC

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

SELECT * FROM orders
ORDER BY order_customer_id

-- COMMAND ----------

SELECT * FROM orders
ORDER BY order_customer_id, order_date

-- COMMAND ----------

SELECT * FROM orders
ORDER BY order_customer_id ASC, order_date DESC

-- COMMAND ----------

CREATE TABLE IF NOT EXISTS student_scores (
	student_id INT,
	student_score INT
);

-- COMMAND ----------

INSERT OVERWRITE student_scores VALUES
(1, 980),
(2, 960),
(3, NULL),
(4, 990),
(5, 920),
(6, 960),
(7, 980),
(8, 960),
(9, 940),
(10, NULL);

-- COMMAND ----------

SELECT * FROM student_scores
ORDER BY student_score ASC NULLS LAST

-- COMMAND ----------

SELECT * FROM student_scores
ORDER BY student_score DESC NULLS FIRST 

-- COMMAND ----------

SELECT * FROM student_scores
ORDER BY student_score DESC

-- COMMAND ----------


