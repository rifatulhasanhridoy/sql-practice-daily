-- 20. First order date and latest order date per customer


SELECT 
customer_id, 
MIN(order_date) as first_order,
MAX(order_date) as lastest_order,
DIFFERENCE(MAX(order_date),MIN(order_date))
FROM orders
GROUP BY customer_id