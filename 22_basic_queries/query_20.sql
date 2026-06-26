-- 20. First order date and latest order date per customer


SELECT 
        c.customer_id, 
        c.name,
        MIN(o.order_date) as first_order,
        MAX(o.order_date) as lastest_order,
        DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS days_active
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY DATEDIFF(DAY, MIN(order_date), MAX(order_date)) DESC
