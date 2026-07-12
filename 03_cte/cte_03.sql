
-- CTE3. Products with above-average rating



WITH product_avt_rt AS (
        SELECT product_id, AVG(rating*1.0) AS avg_rt 
        FROM reviews
GROUP BY product_id )

SELECT product_name, avg_rt
FROM products p
JOIN product_avt_rt ar ON p.product_id= ar.product_id
WHERE avg_rt > (SELECT AVG(rating*1.0) FROM reviews)











