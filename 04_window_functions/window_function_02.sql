
-- WF2. Running total revenue by order date




SELECT 
        o.order_date, 
        SUM(quantity*unit_price) as daily_revenue, 
        SUM(SUM(quantity*unit_price)) OVER(ORDER BY o.order_date)  AS running_total
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date










