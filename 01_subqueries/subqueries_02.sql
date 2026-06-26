-- SQ2. Customers who have placed at least one order


SELECT * FROM customers
WHERE customer_id IN ( SELECT customer_id FROM orders)