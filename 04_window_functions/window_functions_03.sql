
-- WF3. Each order's revenue vs previous order using LAG





SELECT 
        o.order_id, 
        o.order_date,
        SUM(quantity*unit_price) AS revenue,
        LAG(SUM(quantity*unit_price)) OVER( ORDER BY o.order_id) AS prv
FROM orders o 
JOIN order_items oi ON o.order_id=oi.order_id
GROUP BY o.order_id ,  o.order_date





