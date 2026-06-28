
-- CSQ7. Products whose stock is below the average stock of their own category

SELECT product_id, product_name, stock_qty FROM products p0
WHERE stock_qty < (SELECT AVG(stock_qty) FROM products p1 WHERE p1.category_id=p0.category_id)

SELECT product_id, product_name, stock_qty ,stock_per_category FROM
(SELECT product_id, product_name, stock_qty , AVG(stock_qty) OVER( PARTITION BY category_id) AS stock_per_category
FROM products) sub
WHERE stock_qty < stock_per_category
ORDER BY stock_per_category




