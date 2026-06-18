-- 16. Products with above-average unit price in their category

SELECT 
product_id,
product_name, 
unit_price
FROM products p1
WHERE unit_price > (
    SELECT AVG(unit_price) 
    FROM products p2
    WHERE p2.category_id= p1.category_id
)


-- JOIN categories c 
-- ON p.category_id=c.category_id

SELECT * from categories
SELECT * from products




SELECT p.product_name, p.unit_price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.unit_price > (
    SELECT AVG(unit_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);