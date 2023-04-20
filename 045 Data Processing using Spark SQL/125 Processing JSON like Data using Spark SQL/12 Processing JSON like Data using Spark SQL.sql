-- Databricks notebook source
-- MAGIC %md
-- MAGIC 
-- MAGIC Here are the concepts that are important to process JSON Like Data using Spark SQL.
-- MAGIC * Overview of JSON
-- MAGIC * Creating Table with Array Type Column
-- MAGIC * Important Functions Dealing with Array Type Column
-- MAGIC * Creating Table with Struct Type Column
-- MAGIC * Important Functions Dealing with Struct Type Column
-- MAGIC * Creating Table with Array of Structs Type Column
-- MAGIC * Functions to Generate Array Type Results
-- MAGIC * Functions to Generate Struct Type Results

-- COMMAND ----------

USE itversity_retail_db

-- COMMAND ----------

DROP TABLE IF EXISTS users

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phones ARRAY<STRING>
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', ARRAY('+1 (234) 567 8901', '+1 (123) 456 7890')),
  (2, 'Donald', 'Duck', NULL),
  (3, 'Mickey', 'Mouse', ARRAY('+1 (456) 789 0123'))

-- COMMAND ----------

SHOW functions

-- COMMAND ----------

DESCRIBE FUNCTION filter

-- COMMAND ----------

SELECT user_id, filter(user_phones, rec -> rec == '+1 (234) 567 8901') FROM users

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

-- size, explode, explode_outer

-- COMMAND ----------

SELECT user_id, size(user_phones) phone_count
FROM users

-- COMMAND ----------

DESCRIBE FUNCTION nvl2

-- COMMAND ----------

SELECT user_id, nvl2(user_phones, size(user_phones), 0) AS phone_count
FROM users

-- COMMAND ----------

SELECT user_id,
  explode(user_phones) AS user_phone
FROM users

-- COMMAND ----------

SELECT user_id,
  explode_outer(user_phones) AS user_phone
FROM users

-- COMMAND ----------

DROP TABLE IF EXISTS users

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phones STRUCT<home: STRING, mobile: STRING>
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', STRUCT('+1 (234) 567 8901', '+1 (123) 456 7890')),
  (2, 'Donald', 'Duck', STRUCT(NULL, NULL)),
  (3, 'Mickey', 'Mouse', STRUCT('+1 (456) 789 0123', NULL))

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

SELECT user_id, user_phones.*
FROM users

-- COMMAND ----------

SELECT user_id, 
  user_phones.home AS user_phone_home,
  user_phones.mobile AS user_phone_mobile
FROM users

-- COMMAND ----------

SELECT * FROM order_items

-- COMMAND ----------

SELECT order_item_id,
  order_item_order_id,
  order_item_product_id,
  order_item_subtotal,
  STRUCT(order_item_quantity, order_item_product_price) AS order_item_trans_details
FROM order_items

-- COMMAND ----------

DROP TABLE IF EXISTS users

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phones ARRAY<STRUCT<phone_type: STRING, phone_number: STRING>>
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', ARRAY(STRUCT('home', '+1 (234) 567 8901'), STRUCT('mobile', '+1 (123) 456 7890'))),
  (2, 'Donald', 'Duck', NULL),
  (3, 'Mickey', 'Mouse', ARRAY(STRUCT('home', '+1 (123) 456 9012')))

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

WITH user_phones_exploded AS (
  SELECT user_id,
    explode_outer(user_phones) AS user_phone
  FROM users
) SELECT user_id, user_phone.* FROM user_phones_exploded

-- COMMAND ----------

WITH user_phones_exploded AS (
  SELECT user_id,
    explode_outer(user_phones) AS user_phone
  FROM users
) SELECT user_id, 
  user_phone.phone_type AS user_phone_type,
  user_phone.phone_number AS user_phone_number
FROM user_phones_exploded

-- COMMAND ----------

-- split, concat_ws, collect_*, array_*

-- COMMAND ----------

DROP TABLE users

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phone_type STRING,
  user_phone_number STRING
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', 'home', '+1 (234) 567 8901'),
  (1, 'Scott', 'Tiger', 'mobile', '+1 (123) 456 7890'),
  (2, 'Donald', 'Duck', NULL, NULL),
  (3, 'Mickey', 'Mouse', 'home', '+1 (123) 456 9012')

-- COMMAND ----------

SELECT * FROM users
-- 1 Scott Tiger [+1 (234) 567 8901, +1 (123) 456 7890]
-- 2 Donald Duck NULL
-- 3 Mickey Mouse [+1 (123) 456 9012]

-- COMMAND ----------

SELECT user_id,
  user_fname,
  user_lname,
  collect_list(user_phone_number) AS user_phones
FROM users
GROUP BY 1, 2, 3

-- COMMAND ----------

SELECT user_id,
  user_fname,
  user_lname,
  concat_ws(',', collect_list(user_phone_number)) AS user_phones
FROM users
GROUP BY 1, 2, 3

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

SELECT user_id,
  user_fname,
  user_lname,
  STRUCT(user_phone_type, user_phone_number) AS user_phone
FROM users

-- COMMAND ----------

SELECT user_id,
  user_fname,
  user_lname,
  nvl2(user_phone_number, STRUCT(user_phone_type, user_phone_number), NULL) AS user_phone
FROM users

-- COMMAND ----------

SELECT user_id,
  user_fname,
  user_lname,
  collect_list(nvl2(user_phone_number, STRUCT(user_phone_type, user_phone_number), NULL)) AS user_phones
FROM users
GROUP BY 1, 2, 3

-- COMMAND ----------

DROP TABLE users

-- COMMAND ----------

CREATE TABLE users (
  user_id INT,
  user_fname STRING,
  user_lname STRING,
  user_phones STRING
)

-- COMMAND ----------

INSERT INTO users
VALUES
  (1, 'Scott', 'Tiger', '+1 (234) 567 8901,+1 (123) 456 7890'),
  (2, 'Donald', 'Duck', NULL),
  (3, 'Mickey', 'Mouse', '+1 (123) 456 9012')

-- COMMAND ----------

SELECT * FROM users

-- COMMAND ----------

SELECT
  user_id,
  user_fname,
  user_lname,
  split(user_phones, ',') AS user_phones
FROM users

-- COMMAND ----------

SELECT
  user_id,
  user_fname,
  user_lname,
  explode_outer(split(user_phones, ',')) AS user_phone
FROM users

-- COMMAND ----------


