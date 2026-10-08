-- =============================================================================
-- DBMS LAB | EXPERIMENT 05
-- Step 02: Department salary view, employee hierarchy view, recursive CTE
-- MySQL 8.0+ | Requires Experiment 05 Step 01
-- =============================================================================

USE CompanyDB;

-- ----------------------------------------------------------------------------
-- 1. DEPARTMENT SALARY SUMMARY VIEW
-- Show employee count, average, minimum, maximum, and total salary per dept.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW department_salary_summary AS
SELECT
    d.dept_id,
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    SUM(e.salary) AS total_salary
FROM Department AS d
INNER JOIN Employee AS e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT *
FROM department_salary_summary
ORDER BY dept_id;

-- ----------------------------------------------------------------------------
-- 2. EMPLOYEE HIERARCHY VIEW
-- Show each employee's department and immediate manager (NULL for heads).
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW employee_hierarchy AS
SELECT
    e.emp_id,
    e.emp_name,
    e.dept_id,
    d.dept_name,
    e.manager_id,
    m.emp_name AS manager_name,
    e.salary
FROM Employee AS e
INNER JOIN Department AS d
    ON e.dept_id = d.dept_id
LEFT JOIN Employee AS m
    ON e.manager_id = m.emp_id;

SELECT emp_id, emp_name, dept_name, manager_id, manager_name, salary
FROM employee_hierarchy
ORDER BY dept_id, emp_id;

-- ----------------------------------------------------------------------------
-- 3. RECURSIVE CTE: REPORTING CHAIN
-- Anchor at every department head and walk downward to all reportees.
-- CAST ensures the path can hold concatenated employee names in MySQL.
-- ----------------------------------------------------------------------------
WITH RECURSIVE reporting_chain AS (
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        1 AS level,
        CAST(e.emp_name AS CHAR(500)) AS reporting_path
    FROM Employee AS e
    WHERE e.manager_id IS NULL

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id,
        rc.level + 1 AS level,
        CONCAT(rc.reporting_path, ' -> ', e.emp_name) AS reporting_path
    FROM Employee AS e
    INNER JOIN reporting_chain AS rc
        ON e.manager_id = rc.emp_id
)
SELECT emp_id, emp_name, manager_id, level, reporting_path
FROM reporting_chain
ORDER BY reporting_path, emp_id;
