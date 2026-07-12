-- CTE1. Top 3 customers by total spend


WITH customer_spend AS(
    SELECT 
        c.customer_id as customer_id, 
        c.name as name, 
        sum(quantity*unit_price*(1-discount_pct/100)) as total_spend 
    FROM order_items oi 
    JOIN orders o on oi.order_id = o.order_id
    JOIN customers c on o.customer_id = c.customer_id 
    WHERE o.status != 'cancelled'
    GROUP BY c.customer_id, c.name

)
SELECT TOP 3 customer_id,name, total_spend
FROM customer_spend
ORDER BY total_spend DESC



