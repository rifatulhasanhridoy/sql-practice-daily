-- 22. Products with low stock (below 30) that are still being ordered



SELECT p.product_name, p.stock_qty,
       COUNT(oi.item_id) AS times_ordered
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.stock_qty < 30
GROUP BY p.product_name, p.stock_qty
ORDER BY p.stock_qty ASC;