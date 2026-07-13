


-- CTE4. Employee hierarchy using recursive CTE
WITH employee_table AS(


SELECT employee_id,name,role, 0 as level FROM employees 
WHERE manager_id IS NULL
UNION ALL
SELECT e.employee_id, e.name, e.role, et.level+1 FROM employees e
JOIN employee_table et 
ON e.manager_id=et.employee_id




) 

SELECT level, name, role FROM employee_table ORDER BY level, name;


