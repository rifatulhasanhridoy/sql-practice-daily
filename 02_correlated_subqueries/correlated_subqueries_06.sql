-- CSQ6. Customers whose latest order is more recent than their own average order gap
-- (customers who are ordering more frequently lately)


SELECT c.name , o.order_date 
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
WHERE o.order_date = (SELECT MAX(order_date) FROM orders o2 WHERE o2.customer_id=c.customer_id) 
AND (SELECT COUNT(*) FROM orders o3 WHERE o3.customer_id=c.customer_id) > 1





