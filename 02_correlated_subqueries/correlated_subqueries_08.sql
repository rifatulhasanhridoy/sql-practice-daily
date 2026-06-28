
-- CSQ8. Orders handled by an employee who has handled more than 3 orders total



SELECT employee_id, order_id, order_date FROM orders o0
WHERE (SELECT COUNT(employee_id) FROM orders o1 WHERE o1.employee_id=o0.employee_id GROUP BY o1.employee_id) > 3




