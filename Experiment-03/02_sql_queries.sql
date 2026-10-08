-- ============================================================================
-- DBMS LAB | EXPERIMENT 03
-- SQL operations: Selection, Projection, Aggregates, GROUP BY, HAVING,
--                 CASE, ORDER BY, and JOIN
-- Run 01_company_schema_and_data.sql FIRST.
-- ============================================================================

USE CompanyDB;

-- 1. SELECTION
-- Display all employees with a salary greater than 70,000.
SELECT *
FROM Employee
WHERE salary > 70000;

-- 2. PROJECTION
-- Display only employee names and salaries.
SELECT emp_name, salary
FROM Employee;

-- 3. AGGREGATE FUNCTIONS
-- Count employees and calculate salary statistics.
SELECT
    COUNT(*) AS total_employees,
    AVG(salary) AS average_salary,
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary,
    SUM(salary) AS total_salary
FROM Employee;

-- 4. GROUP BY
-- Find employee count and average salary for each department.
SELECT
    d.dept_name,
    COUNT(e.emp_id) AS employee_count,
    AVG(e.salary) AS average_salary
FROM Department AS d
JOIN Employee AS e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- 5. HAVING
-- Show departments with an average salary greater than 65,000.
SELECT
    d.dept_name,
    AVG(e.salary) AS average_salary
FROM Department AS d
JOIN Employee AS e
    ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 65000;

-- 6. CASE EXPRESSION
-- Classify each employee into High, Medium, or Low Salary.
SELECT
    emp_name,
    salary,
    CASE
        WHEN salary >= 75000 THEN 'High Salary'
        WHEN salary >= 60000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS salary_category
FROM Employee;

-- 7. ORDER BY
-- Display employee names and salaries in descending salary order.
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;

-- 8. THREE-TABLE JOIN
-- Display employees with their department, project, and salary.
SELECT
    e.emp_name,
    d.dept_name,
    p.project_name,
    e.salary
FROM Employee AS e
JOIN Department AS d
    ON e.dept_id = d.dept_id
JOIN Project AS p
    ON e.project_id = p.project_id
ORDER BY d.dept_name, e.emp_name;
