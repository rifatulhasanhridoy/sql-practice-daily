-- CSQ1. Products priced above average of their own category

SELECT category_id, product_name ,unit_price FROM products p1
WHERE unit_price > (select AVG(unit_price) FROM products p2 WHERE p2.category_id= p1.category_id)


