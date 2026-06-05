# SQL Daily Practice

A personal repository to document my daily SQL practice and build consistency as an aspiring data analyst.  
I write and push **2–3 queries every day** — covering everything from basic filters to advanced window functions.

---

## Purpose

I am currently pursuing an **M.S. in Applied Statistics and Data Science** at Jahangirnagar University  
and actively building skills for data analyst roles in Bangladesh.

This repo serves three goals:
- Stay consistent with SQL by practicing daily
- Build a visible track record of growth
- Prepare for real-world data tasks in internships and jobs

---

## The Dataset

All queries run against a custom **retail e-commerce schema** built in **SQL Server 2022**,  
modeled after a Bangladeshi online retail business (think Daraz / Chaldal style operations).

### Tables

| Table | Description |
|---|---|
| `customers` | 20 customers across Dhaka, Chittagong, Sylhet and other cities |
| `categories` | Product hierarchy with parent and child categories |
| `products` | 20 products across electronics, clothing, food, and home goods |
| `employees` | 8 employees with self-referencing manager hierarchy |
| `orders` | 20 orders with status tracking (pending → delivered) |
| `order_items` | Line items per order with quantity, price, and discount |
| `payments` | Payment records with methods like bKash, Nagad, card, COD |
| `reviews` | Customer ratings (1–5) and comments per product |

### Schema diagram

```
customers ──< orders ──< order_items >── products >── categories
                │                                          │
           employees                                    reviews
                                                     (customers + products)
              orders ──< payments
```

---

## Topics Covered

| Level | Topics |
|---|---|
| Basic | `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, `LIKE`, `BETWEEN`, `GROUP BY` |
| Joins | `INNER JOIN`, `LEFT JOIN`, `SELF JOIN`, multi-table joins |
| Aggregation | `SUM`, `AVG`, `COUNT`, `HAVING`, revenue calculations |
| Subqueries | Correlated subqueries, `IN`, `NOT IN`, `EXISTS` |
| CTE | `WITH` clause, multi-step logic |
| Window Functions | `RANK()`, `ROW_NUMBER()`, `LAG()`, `SUM() OVER()`, running totals |

---

## Folder Structure

```
sql-practice-daily/
├── ddl.sql                  # Full schema + seed data (SQL Server)
├── basics/
│   ├── day01_select_where.sql
│   └── day02_group_by.sql
├── intermediate/
│   ├── day03_joins.sql
│   └── day04_subqueries.sql
├── advanced/
│   ├── day05_cte.sql
│   └── day06_window_functions.sql
└── README.md
```

---

## Tools

- **Database:** SQL Server 2022 (Docker)
- **Editor:** Azure Data Studio
- **Schema style:** Retail e-commerce, Bangladeshi business context

---

## About Me

**Rifatul Hasan Hridoy**  
M.S. in Applied Statistics and Data Science — Jahangirnagar University  
Aspiring Data Analyst | SQL · Python · Power BI · Excel  

[GitHub](https://github.com/rifatulhasanhridoy) · [LinkedIn](https://linkedin.com/in/rifatulhasanhridoy)
