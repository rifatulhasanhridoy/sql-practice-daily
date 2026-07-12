-- CTE2. Monthly revenue with month-on-month change




WITH monthly AS (
    SELECT FORMAT(o.order_date, 'yyyy-MM') AS month,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY FORMAT(o.order_date, 'yyyy-MM')
)
SELECT month, revenue,
       revenue - LAG(revenue) OVER (ORDER BY month) AS mom_change
FROM monthly;
