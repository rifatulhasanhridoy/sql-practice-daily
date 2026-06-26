-- CSQ2. Customers who placed more than 2 orders

SELECT customer_id, c.name FROM customers c
WHERE 
      (SELECT COUNT(*) FROM orders o 
      WHERE o.customer_id=c.customer_id) 
      >1





