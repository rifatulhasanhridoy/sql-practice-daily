-- 19. Each product's revenue vs total revenue (contribution %)

SELECT  
    p.product_id, 
    p.product_name , 
    sum(quantity * oi.unit_price) as product_revenue, 
    100*(sum(quantity * oi.unit_price)/sum(sum(quantity * oi.unit_price)) OVER()) as contribution
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY product_revenue DESC

