SELECT count(*) FROM daily_product_revenue;
SELECT * FROM daily_product_revenue
ORDER BY order_date, order_revenue DESC;

-- rank() OVER ()
-- dense_rank() OVER ()

-- Global Ranking
   -- rank() OVER (ORDER BY col1 DESC)
-- Ranking based on key or partition key
   -- rank() OVER (PARTITION BY col2 ORDER BY col1 DESC)