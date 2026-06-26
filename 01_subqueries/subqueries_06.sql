-- SQ6. Products never reviewed


SELECT product_name FROM products
WHERE product_id  NOT IN (
SELECT DISTINCT product_id FROM reviews) 

