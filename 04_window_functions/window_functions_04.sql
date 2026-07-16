
-- WF4. Most recent order per customer using ROW_NUMBER





WITH ranked AS(
SELECT c.customer_id, order_id, order_date,
RANK() OVER( PARTITION BY c.customer_id  ORDER BY order_date desc ) AS rnk
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
)

SELECT customer_id, order_id, order_date  FROM ranked
WHERE rnk=1







WITH ranked AS (
    SELECT customer_id, order_id, order_date,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date DESC
           ) AS rn
    FROM orders
)
SELECT customer_id, order_id, order_date
FROM ranked WHERE rn = 1;
