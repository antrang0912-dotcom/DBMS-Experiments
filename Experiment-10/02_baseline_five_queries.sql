-- EXPERIMENT 10 | STEP 2: BEFORE OPTIMIZATION
-- Prerequisite: run 01_create_and_populate_employee_data.sql.
-- IMPORTANT: Run this file BEFORE 03_optimized_five_queries.sql.
-- MySQL EXPLAIN ANALYZE executes the query: actual timings vary by system.
USE QueryLabDB;

-- Query 1: YEAR() on indexed-capable hire_date column; no secondary index yet.
EXPLAIN SELECT emp_id, emp_name, hire_date
FROM EmployeeData WHERE YEAR(hire_date) = 2022;
EXPLAIN ANALYZE SELECT emp_id, emp_name, hire_date
FROM EmployeeData WHERE YEAR(hire_date) = 2022;

-- Query 2: leading wildcard searches for '999' ANYWHERE in the name.
EXPLAIN SELECT emp_id, emp_name
FROM EmployeeData WHERE emp_name LIKE '%999%';
EXPLAIN ANALYZE SELECT emp_id, emp_name
FROM EmployeeData WHERE emp_name LIKE '%999%';

-- Query 3: department equality, before secondary indexes.
EXPLAIN SELECT emp_id, emp_name, salary
FROM EmployeeData WHERE department = 'Finance';
EXPLAIN ANALYZE SELECT emp_id, emp_name, salary
FROM EmployeeData WHERE department = 'Finance';

-- Query 4: correlated AVG(salary) comparison.
EXPLAIN SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData AS e
WHERE e.salary > (
    SELECT AVG(e2.salary) FROM EmployeeData AS e2
    WHERE e2.department = e.department
);
EXPLAIN ANALYZE SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData AS e
WHERE e.salary > (
    SELECT AVG(e2.salary) FROM EmployeeData AS e2
    WHERE e2.department = e.department
);

-- Query 5: OR across two columns.
EXPLAIN SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE department = 'IT' OR city = 'Lucknow';
EXPLAIN ANALYZE SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE department = 'IT' OR city = 'Lucknow';

-- Record the access path, estimated rows, actual rows, and actual time
-- for each BEFORE query in the table in README.md.
