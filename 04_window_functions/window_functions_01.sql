-- WF1. Rank customers by total spend

SELECT 
        c.name, 
        SUM(quantity*unit_price) AS total_spend,
        RANK()  OVER  (ORDER BY SUM(quantity*unit_price) DESC) AS rnk
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi  ON o.order_id = oi.order_id
GROUP BY c.name



