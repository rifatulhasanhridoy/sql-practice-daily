
-- CTE5. Order item total vs payment amount side by side






WITH order_total AS(
    SELECT order_id, SUM(quantity * unit_price * (1 - discount_pct/100)) AS item_total
    FROM order_items 
    GROUP BY order_id
),

paid_total AS (

    SELECT order_id, SUM(amount) AS paid_total
    FROM payments
    GROUP BY order_id
)
SELECT o.order_id, ot.item_total, pt.paid_total, ot.item_total- pt.paid_total
FROM orders o 
LEFT JOIN order_total ot ON o.order_id=ot.order_id
LEFT JOIN paid_total pt ON o.order_id= pt.order_id









