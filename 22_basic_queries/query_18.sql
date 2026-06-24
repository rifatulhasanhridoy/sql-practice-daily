-- 18. Orders where total item value exceeds payment amount (data anomalies)

SELECT * FROM orders
SELECT * FROM order_items
SELECT * from payments


SELECT order_id, price, payment_amount
FROM(
SELECT oi.order_id, SUM(quantity*unit_price) as price, AVG(amount) as payment_amount
FROM order_items oi
JOIN payments p
ON oi.order_id=p.order_id
GROUP  BY oi.order_id
) t
WHERE price> payment_amount






SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS items_total,
       p.amount AS paid
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_id, p.amount
HAVING SUM(oi.quantity * oi.unit_price) > p.amount;



