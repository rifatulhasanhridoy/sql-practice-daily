-- 17. Customers who ordered more than once



SELECT o.customer_id, c.name , COUNT(order_id) as total_orders
FROM orders o JOIN customers c on o.customer_id = c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(order_id) > 1
ORDER BY COUNT(order_id)


