-- CSQ3. Products ordered more than the average order frequency

SELECT product_id, product_name FROM products p 
WHERE  (SELECT COUNT(*) FROM order_items oi WHERE oi.product_id=p.product_id) > 
(SELECT AVG(order_count*1.0) FROM (SELECT COUNT(*) AS order_count FROM order_items GROUP BY product_id) sub) 






