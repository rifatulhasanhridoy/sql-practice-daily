-- SQ4. Most expensive product in each category


SELECT category_id, product_name, unit_price FROM products 

WHERE unit_price IN (SELECT MAX(unit_price) FROM products
GROUP BY category_id)



