-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Let us go through the basic transformations using Spark SQL.
-- MAGIC * Projecting the Data from Spark Metastore Tables
-- MAGIC * Filtering Data from Spark Metastore Tables
-- MAGIC * Peforming Aggregations on Spark Metastore Tables
-- MAGIC * Joining Multiple Spark Metastore Tables
-- MAGIC * Sorting Data in Spark Metastore Tables
-- MAGIC * Creating Tables based on Query Results
-- MAGIC * Inserting Data into Tables based on Query Results
-- MAGIC * Merging Data into Tables based on Query Results

-- COMMAND ----------

DROP DATABASE itversity_retail_db CASCADE

-- COMMAND ----------

CREATE DATABASE itversity_retail_db

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

CREATE TABLE orders (
  order_id INT,
  order_date DATE,
  order_customer_id INT,
  order_status STRING
)

-- COMMAND ----------

DESCRIBE FORMATTED orders

-- COMMAND ----------

CREATE OR REPLACE TEMPORARY VIEW orders_v (
  order_id INT,
  order_date DATE,
  order_customer_id INT,
  order_status STRING
) USING CSV
OPTIONS (
  path='dbfs:/public/retail_db/orders'
)

-- COMMAND ----------

INSERT INTO orders
SELECT * FROM orders_v

-- COMMAND ----------

SELECT * FROM orders

-- COMMAND ----------

SELECT count(*) FROM orders

-- COMMAND ----------

CREATE TABLE order_items (
  order_item_id INT,
  order_item_order_id INT,
  order_item_product_id INT,
  order_item_quantity INT,
  order_item_subtotal FLOAT,
  order_item_product_price FLOAT
)

-- COMMAND ----------

CREATE OR REPLACE TEMPORARY VIEW order_items_v (
  order_item_id INT,
  order_item_order_id INT,
  order_item_product_id INT,
  order_item_quantity INT,
  order_item_subtotal FLOAT,
  order_item_product_price FLOAT
) USING CSV
OPTIONS (
  path='dbfs:/public/retail_db/order_items'
)

-- COMMAND ----------

INSERT INTO order_items
SELECT * FROM order_items_v

-- COMMAND ----------

SELECT * FROM order_items

-- COMMAND ----------

SELECT count(*) FROM order_items

-- COMMAND ----------

SHOW tables

-- COMMAND ----------


