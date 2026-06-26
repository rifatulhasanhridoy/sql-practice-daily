-- SQ3. Orders that contain more than 2 line items

SELECT order_id FROM orders
WHERE order_id IN (
    SELECT order_id FROM order_items
    GROUP BY order_id
    HAVING COUNT(*) > 2
);