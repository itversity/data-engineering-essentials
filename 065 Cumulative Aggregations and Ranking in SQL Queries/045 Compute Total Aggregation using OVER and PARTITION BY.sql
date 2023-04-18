SELECT dr.*,
    sum(order_revenue) OVER (PARTITION BY 1) AS total_order_revenue
FROM daily_revenue AS dr
ORDER BY 1;