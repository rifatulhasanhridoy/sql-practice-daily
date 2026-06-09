

-- 13. Average order value per city




SELECT
city,
ROUND(AVG(order_value), 2)avg_order_value
FROM(
SELECT
o.shipping_city as city ,
oi.order_id,
SUM(quantity*unit_price*(1-discount_pct/100)) as order_value
from order_items oi
JOIN orders o
on oi.order_id = o.order_id
group by shipping_city , oi.order_id

) sub
GROUP BY city;






```sql
-- 14. Categories with more than 2 products
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 2;
```

```sql
-- 15. Months with total revenue above 50,000 BDT
SELECT FORMAT(o.order_date, 'yyyy-MM') AS month,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status != 'cancelled'
GROUP BY FORMAT(o.order_date, 'yyyy-MM')
HAVING SUM(oi.quantity * oi.unit_price) > 50000
ORDER BY month;
```

---

**Subquery & Filtering**

```sql
-- 16. Products with above-average unit price in their category
SELECT p.product_name, p.unit_price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.unit_price > (
    SELECT AVG(unit_price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);
```

```sql
-- 17. Customers who ordered more than once
SELECT c.name, COUNT(o.order_id) AS total_orders
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) > 1;
```

```sql
-- 18. Orders where total item value exceeds payment amount (data anomalies)
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS items_total,
       p.amount AS paid
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY o.order_id, p.amount
HAVING SUM(oi.quantity * oi.unit_price) > p.amount;
```

---

**Window Functions**

```sql
-- 19. Each product's revenue vs total revenue (contribution %)
SELECT p.product_name,
       SUM(oi.quantity * oi.unit_price) AS product_revenue,
       ROUND(
           100.0 * SUM(oi.quantity * oi.unit_price) /
           SUM(SUM(oi.quantity * oi.unit_price)) OVER (), 2
       ) AS revenue_pct
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY product_revenue DESC;
```

```sql
-- 20. First order date and latest order date per customer
SELECT c.name,
       MIN(o.order_date) AS first_order,
       MAX(o.order_date) AS latest_order,
       DATEDIFF(DAY, MIN(o.order_date), MAX(o.order_date)) AS days_active
FROM customers c JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;
```

---

**Advanced**

```sql
-- 21. Employee performance: revenue handled per employee
WITH emp_revenue AS (
    SELECT e.name AS employee,
           e.role,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) AS total_revenue
    FROM employees e
    JOIN orders o ON e.employee_id = o.employee_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'cancelled'
    GROUP BY e.employee_id, e.name, e.role
)
SELECT employee, role, total_revenue,
       RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank
FROM emp_revenue;
```

```sql
-- 22. Products with low stock (below 30) that are still being ordered
SELECT p.product_name, p.stock_qty,
       COUNT(oi.item_id) AS times_ordered
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
WHERE p.stock_qty < 30
GROUP BY p.product_name, p.stock_qty
ORDER BY p.stock_qty ASC;
```

---

Each one targets something specific — window `OVER()`, correlated subquery, `DATEDIFF`, `HAVING` on joins, contribution percentage. Let me know if you want hints or explanations for any of them.