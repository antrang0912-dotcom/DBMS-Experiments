-- =============================================================================
-- DBMS LAB | EXPERIMENT 04
-- JOINs, correlated subqueries, EXISTS, and simulated set operations
-- Database: MySQL 8.0+ | Uses the CompanyDB schema from Experiment 03
-- =============================================================================
-- PREREQUISITE:
-- Run ../Experiment-03/01_company_schema_and_data.sql once to create CompanyDB
-- with 30 employees, 5 departments, and 8 projects.
-- This file contains SELECT statements only. It does not modify the database.

USE CompanyDB;

-- -----------------------------------------------------------------------------
-- 1. INNER JOIN
-- Display employee IDs, names, salaries, and corresponding department names.
-- Expected with Experiment 03 sample data: 30 rows.
-- -----------------------------------------------------------------------------
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    d.dept_name
FROM Employee AS e
INNER JOIN Department AS d
    ON e.dept_id = d.dept_id
ORDER BY e.emp_id;

-- -----------------------------------------------------------------------------
-- 2. LEFT JOIN
-- Display every department and any employees assigned to it.
-- Departments with no employee would still appear with NULL employee columns.
-- In Experiment 03's sample data, every department has 6 employees (30 rows).
-- -----------------------------------------------------------------------------
SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name,
    e.salary
FROM Department AS d
LEFT JOIN Employee AS e
    ON d.dept_id = e.dept_id
ORDER BY d.dept_id, e.emp_id;

-- -----------------------------------------------------------------------------
-- 3. SELF JOIN
-- Compare pairs of employees working in the same department.
-- e1.emp_id < e2.emp_id avoids pairing an employee with themself and
-- avoids duplicate reverse-order pairs. Display just the first 10 pairs.
-- -----------------------------------------------------------------------------
SELECT
    e1.emp_name AS employee_1,
    e2.emp_name AS employee_2,
    e1.dept_id,
    e1.salary AS salary_1,
    e2.salary AS salary_2
FROM Employee AS e1
INNER JOIN Employee AS e2
    ON e1.dept_id = e2.dept_id
   AND e1.emp_id < e2.emp_id
ORDER BY e1.dept_id, e1.emp_id, e2.emp_id
LIMIT 10;

-- -----------------------------------------------------------------------------
-- 4. THREE-WAY JOIN
-- Combine Employee, Department, and Project to show the project assigned
-- to each employee, together with department and salary.
-- Expected with Experiment 03 sample data: 30 rows.
-- -----------------------------------------------------------------------------
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee AS e
INNER JOIN Department AS d
    ON e.dept_id = d.dept_id
INNER JOIN Project AS p
    ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;

-- -----------------------------------------------------------------------------
-- 5. CORRELATED SUBQUERY
-- Employees whose salary exceeds the average salary in their own department.
-- The inner subquery uses the current outer row's e.dept_id.
-- -----------------------------------------------------------------------------
SELECT
    e.emp_id,
    e.emp_name,
    e.salary,
    e.dept_id
FROM Employee AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee AS e2
    WHERE e2.dept_id = e.dept_id
)
ORDER BY e.dept_id, e.salary DESC;

-- -----------------------------------------------------------------------------
-- 6. EXISTS
-- Departments with at least one employee earning more than 80,000.
-- Expected with Experiment 03 sample data: IT and Finance.
-- -----------------------------------------------------------------------------
SELECT
    d.dept_id,
    d.dept_name
FROM Department AS d
WHERE EXISTS (
    SELECT 1
    FROM Employee AS e
    WHERE e.dept_id = d.dept_id
      AND e.salary > 80000
)
ORDER BY d.dept_id;

-- -----------------------------------------------------------------------------
-- 7. SIMULATED INTERSECT
-- Set A: Employees in IT (dept_id = 1).
-- Set B: Employees with a salary greater than 70,000.
-- Return IDs that occur in BOTH sets using IN + IN.
-- -----------------------------------------------------------------------------
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE emp_id IN (
    SELECT emp_id
    FROM Employee
    WHERE dept_id = 1
)
AND emp_id IN (
    SELECT emp_id
    FROM Employee
    WHERE salary > 70000
)
ORDER BY emp_id;

-- -----------------------------------------------------------------------------
-- 8. SIMULATED EXCEPT
-- Set A: Employees earning more than 70,000.
-- Set B: Employees in IT (dept_id = 1).
-- Return IDs in A but NOT in B using IN + NOT IN.
-- -----------------------------------------------------------------------------
SELECT
    emp_id,
    emp_name,
    salary
FROM Employee
WHERE emp_id IN (
    SELECT emp_id
    FROM Employee
    WHERE salary > 70000
)
AND emp_id NOT IN (
    SELECT emp_id
    FROM Employee
    WHERE dept_id = 1
)
ORDER BY emp_id;
