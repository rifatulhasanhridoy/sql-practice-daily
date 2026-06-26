-- SQ1. Products more expensive than the average price

SELECT * FROM products
WHERE unit_price > (SELECT AVG(unit_price) from products)







