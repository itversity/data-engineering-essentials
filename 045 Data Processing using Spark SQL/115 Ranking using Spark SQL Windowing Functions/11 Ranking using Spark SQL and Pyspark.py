# Databricks notebook source
# MAGIC %md
# MAGIC 
# MAGIC Let us go through ranking using Spark SQL and Pyspark.
# MAGIC * Create Data Frame for Daily Product Revenue
# MAGIC * Create Temporary View for Daily Product Revenue
# MAGIC * Ranking using Spark SQL (using `OVER (PARTITION BY grouping_column ORDER BY sorting_column)`)
# MAGIC * Ranking using Pyspark Data Frame APIs (using functions from `pyspark.sql.window`)

# COMMAND ----------

daily_product_revenue = spark. \
    read. \
    format('delta'). \
    load('dbfs:/public/retail_db/daily_product_revenue')

# COMMAND ----------

daily_product_revenue.createOrReplaceTempView('daily_product_revenue')

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC SHOW tables

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC SELECT count(*) FROM daily_product_revenue

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC SELECT dpr.*,
# MAGIC   dense_rank() OVER (PARTITION BY order_date ORDER BY revenue DESC) AS drnk
# MAGIC FROM daily_product_revenue AS dpr
# MAGIC ORDER BY dpr.order_date, dpr.revenue DESC

# COMMAND ----------

# MAGIC %sql
# MAGIC 
# MAGIC WITH dpr_ranked AS (
# MAGIC   SELECT dpr.*,
# MAGIC     dense_rank() OVER (PARTITION BY order_date ORDER BY revenue DESC) AS drnk
# MAGIC   FROM daily_product_revenue AS dpr
# MAGIC ) SELECT * FROM dpr_ranked 
# MAGIC WHERE drnk <= 5
# MAGIC ORDER BY order_date, revenue DESC

# COMMAND ----------

from pyspark.sql.functions import col

# COMMAND ----------

from pyspark.sql.window import Window

# COMMAND ----------

spec = Window. \
    partitionBy('order_date'). \
    orderBy(col('revenue').desc())

# COMMAND ----------

from pyspark.sql.functions import dense_rank

# COMMAND ----------

daily_product_revenue. \
    withColumn('drnk', dense_rank().over(spec)). \
    filter('drnk <= 5'). \
    orderBy('order_date', col('revenue').desc()). \
    show()

# COMMAND ----------


