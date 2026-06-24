-- 21. Employee performance: revenue handled per employee



WITH emp_revenue AS
(
    SELECT 
        em.employee_id AS employee_id, 
        em.name as name,
        em.role as  role,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) as revenue
    FROM order_items oi
    JOIN orders o
    ON oi.order_id=o.order_id
    JOIN employees em
    ON o.employee_id=em.employee_id
    WHERE o.status != 'cancelled'
    GROUP BY em.employee_id, em.role, em.name
)
SELECT employee_id,name,  role, revenue, RANK() OVER( ORDER BY revenue DESC)  revenue_rank
FROM emp_revenue





