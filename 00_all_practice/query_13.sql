-- 13. Average order value per city



SELECT
    city,
    ROUND (AVG(order_value), 2)avg_order_value
FROM(
    SELECT
        o.shipping_city AS city ,
        oi.order_id,
        SUM(quantity*unit_price*(1-discount_pct/100)) AS order_value
    FROM order_items oi
    JOIN orders o
    ON oi.order_id = o.order_id
    GROUP BY shipping_city , oi.order_id

) sub
GROUP BY city;