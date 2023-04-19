SELECT to_char(dr.order_date::timestamp, 'yyyy-MM') AS order_month,
    dr.order_date,
    dr.order_revenue,
    sum(order_revenue) OVER (
        PARTITION BY to_char(dr.order_date::timestamp, 'yyyy-MM')
    ) AS monthly_order_revenue
FROM daily_revenue AS dr
ORDER BY 2;