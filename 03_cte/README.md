# Common Table Expressions (CTE)

A personal study notebook on CTEs — what they are, how they work, and how I applied them in practice queries against a retail e-commerce schema (SQL Server).

---

## What is a CTE?

A CTE (Common Table Expression) is a **temporary named result set** that you define at the beginning of a query using the `WITH` keyword. It exists only for the duration of that single query — it is not stored anywhere permanently.

Think of it like giving a name to a subquery so you can refer to it cleanly, instead of nesting it deep inside your main query.

**Basic syntax:**

```sql
WITH cte_name AS (
    -- your query here
)
SELECT * FROM cte_name;
```

You can also chain multiple CTEs together:

```sql
WITH
cte_one AS (
    SELECT ...
),
cte_two AS (
    SELECT ... FROM cte_one
)
SELECT * FROM cte_two;
```

---

## Why use a CTE instead of a subquery?

| | Subquery | CTE |
|---|---|---|
| Readability | Gets messy when nested | Clean, reads top to bottom |
| Reusability | Can't reuse in same query | Can reference the same CTE multiple times |
| Debugging | Hard to isolate | You can run just the CTE part to check results |
| Recursion | Not possible | Possible with recursive CTE |

---

## Types of CTE

### 1. Simple CTE
A single CTE that computes something once and is used in the main query.
Used when you want to clean up a complex calculation and refer to it by name.

```sql
WITH customer_spend AS (
    SELECT customer_id, SUM(amount) AS total
    FROM orders
    GROUP BY customer_id
)
SELECT * FROM customer_spend WHERE total > 5000;
```

---

### 2. Multiple CTE (Chained)
Two or more CTEs defined together, separated by commas. Later CTEs can reference earlier ones.
Used when your logic has multiple steps and each step depends on the previous.

```sql
WITH
step_one AS (
    SELECT ...
),
step_two AS (
    SELECT ... FROM step_one
)
SELECT * FROM step_two;
```

---

### 3. Recursive CTE
A CTE that references itself. It has two parts joined by `UNION ALL`:
- **Anchor member** — the starting point (runs once)
- **Recursive member** — keeps running until no more rows are returned

Used for hierarchical data like org charts, category trees, or finding paths.

```sql
WITH recursive_cte AS (
    -- Anchor: start from the top
    SELECT employee_id, name, manager_id, 0 AS level
    FROM employees WHERE manager_id IS NULL

    UNION ALL

    -- Recursive: find direct reports of previous level
    SELECT e.employee_id, e.name, e.manager_id, r.level + 1
    FROM employees e
    JOIN recursive_cte r ON e.manager_id = r.employee_id
)
SELECT * FROM recursive_cte;
```

---

## My Practice Queries

### CTE1 — Top 3 customers by total spend
**Type:** Simple CTE

**What it does:** Calculates total spend per customer (excluding cancelled orders), then picks the top 3.

**Why CTE here:** The spend calculation is complex enough that doing it inline inside a `SELECT TOP 3` would be unreadable. The CTE names it `customer_spend` and keeps the final SELECT clean.

```sql
WITH customer_spend AS (
    SELECT c.customer_id, c.name,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct/100)) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status != 'cancelled'
    GROUP BY c.customer_id, c.name
)
SELECT TOP 3 name, total_spent
FROM customer_spend
ORDER BY total_spent DESC;
```

---

### CTE2 — Monthly revenue with month-on-month change
**Type:** Simple CTE + Window Function (`LAG`)

**What it does:** First calculates total revenue per month, then compares each month to the previous one using `LAG()`.

**Why CTE here:** You cannot use `LAG()` directly on a `GROUP BY` result in the same query level. The CTE first aggregates by month, and then the outer query applies the window function on top of that clean result.

```sql
WITH monthly AS (
    SELECT FORMAT(o.order_date, 'yyyy-MM') AS month,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY FORMAT(o.order_date, 'yyyy-MM')
)
SELECT month, revenue,
       revenue - LAG(revenue) OVER (ORDER BY month) AS mom_change
FROM monthly;
```

---

### CTE3 — Products with above-average rating
**Type:** Simple CTE + Scalar Subquery

**What it does:** Calculates average rating per product, then filters for products whose average is above the overall average rating across all products.

**Why CTE here:** The per-product average needs to be computed first before it can be compared. Without CTE this would require a nested subquery inside another subquery — messy to read.

```sql
WITH avg_rating AS (
    SELECT product_id, AVG(rating * 1.0) AS avg_r
    FROM reviews
    GROUP BY product_id
)
SELECT p.product_name, ar.avg_r
FROM products p
JOIN avg_rating ar ON p.product_id = ar.product_id
WHERE ar.avg_r > (SELECT AVG(rating * 1.0) FROM reviews);
```

---

### CTE4 — Employee hierarchy using recursive CTE
**Type:** Recursive CTE

**What it does:** Starts from the CEO (manager_id IS NULL) and recursively finds all employees level by level — like unfolding an org chart.

**Why CTE here:** Hierarchical data cannot be queried with regular JOINs because you do not know how many levels deep it goes. Recursive CTE solves this by repeating until no new rows are found.

**How the recursion works:**
1. Anchor: finds the CEO (level 0)
2. Recursive step: finds everyone who reports to the previous level
3. Stops when no more employees are found

```sql
WITH emp_tree AS (
    -- Anchor member: start from top (CEO)
    SELECT employee_id, name, role, manager_id, 0 AS level
    FROM employees WHERE manager_id IS NULL

    UNION ALL

    -- Recursive member: find direct reports
    SELECT e.employee_id, e.name, e.role, e.manager_id, et.level + 1
    FROM employees e
    JOIN emp_tree et ON e.manager_id = et.employee_id
)
SELECT level, name, role FROM emp_tree ORDER BY level, name;
```

---

### CTE5 — Order item total vs payment amount side by side
**Type:** Multiple CTE (Chained)

**What it does:** Calculates order item totals in one CTE and payment totals in another, then joins them to show any difference — useful for finding billing anomalies.

**Why CTE here:** Two independent aggregations need to happen separately and then be joined. Doing both in subqueries inside a single SELECT would create deeply nested, unreadable SQL. Two named CTEs make the logic obvious.

```sql
WITH order_totals AS (
    SELECT order_id,
           SUM(quantity * unit_price * (1 - discount_pct/100)) AS item_total
    FROM order_items GROUP BY order_id
),
payment_totals AS (
    SELECT order_id, SUM(amount) AS paid_total
    FROM payments GROUP BY order_id
)
SELECT o.order_id, ot.item_total, pt.paid_total,
       ot.item_total - pt.paid_total AS difference
FROM orders o
JOIN order_totals ot ON o.order_id = ot.order_id
LEFT JOIN payment_totals pt ON o.order_id = pt.order_id;
```

---

### CTE6 — Category revenue share %
**Type:** Simple CTE + Window Function (`SUM() OVER()`)

**What it does:** Calculates revenue per category, then expresses each category's revenue as a percentage of total revenue using `SUM() OVER()`.

**Why CTE here:** The revenue per category must be computed first. Then `SUM(revenue) OVER()` in the outer query calculates the grand total across all categories in one pass — without needing a second query or a self-join.

```sql
WITH cat_revenue AS (
    SELECT c.category_name,
           SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
)
SELECT category_name, revenue,
       ROUND(100.0 * revenue / SUM(revenue) OVER(), 2) AS pct_share
FROM cat_revenue
ORDER BY revenue DESC;
```

---

## Query Type Summary

| Query | CTE Type | Key concept used |
|---|---|---|
| CTE1 — Top 3 spenders | Simple | Aggregation + TOP N |
| CTE2 — Monthly MoM change | Simple + Window | LAG() over CTE result |
| CTE3 — Above-average ratings | Simple | CTE + scalar subquery filter |
| CTE4 — Employee hierarchy | Recursive | UNION ALL self-reference |
| CTE5 — Billing anomaly check | Multiple (chained) | Two CTEs joined together |
| CTE6 — Category revenue share | Simple + Window | SUM() OVER() for % share |

---

## Key things to remember

- A CTE only lives for the duration of the query — it is not a table or a view
- You can define as many CTEs as you need before the final SELECT
- Recursive CTEs must have a termination condition — the recursion stops when the recursive member returns no rows
- CTEs make debugging easier — you can run just the CTE block to inspect intermediate results
- In SQL Server, use `TOP N` inside the final SELECT, not inside the CTE itself

---

*Schema: Retail e-commerce database — customers, orders, order_items, products, categories, employees, payments, reviews*
*Database: SQL Server 2022*
