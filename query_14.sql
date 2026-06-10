-- 14. Categories with more than 2 products

SELECT * from categories
SELECT  p.category_id, c.category_name, count(product_id) as count_of_product
from products p
join categories c
ON p.category_id = c.category_id
GROUP BY p.category_id, category_name
HAVING count(product_id) > 2
ORDER BY count(product_id)  DESC
