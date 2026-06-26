-- SQ5. Employees who handled at least one delivered order

SELECT name FROM employees
WHERE employee_id IN (SELECT DISTINCT employee_id from orders WHERE status= 'delivered')

