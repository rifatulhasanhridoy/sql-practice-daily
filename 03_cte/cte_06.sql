
-- CTE6. Category revenue share %

WITH cat_revenue AS(
    SELECT 
        c.category_name , 
        SUM( quantity * oi.unit_price*(1-discount_pct/100)) AS revenue
    FROM order_items oi 
    JOIN products p ON oi.product_id= p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
)
SELECT category_name, revenue,
       ROUND(100 * revenue/SUM(revenue) OVER(), 2) as pct_share
FROM cat_revenue
ORDER BY revenue DESC





