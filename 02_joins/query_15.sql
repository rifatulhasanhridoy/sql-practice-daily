-- 15. Months with total revenue above 50,000 BDT


SELECT 
    order_year,
    order_month,
    ROUND(revenue, 2)
FROM
    (SELECT 
        YEAR(order_date)  as order_year,
        MONTH(order_date)  as order_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi 
    JOIN orders o 
    ON oi.order_id=o.order_id
    WHERE o.status != 'cancelled'
    GROUP BY YEAR(order_date) , MONTH(order_date)
) t
WHERE revenue > 50000
ORDER BY revenue DESC






