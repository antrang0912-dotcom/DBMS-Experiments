-- =============================================================================
-- DBMS LAB | EXPERIMENT 04
-- EXPLAIN: compare optimizer plans for different query patterns
-- Database: MySQL 8.0+ | Uses CompanyDB from Experiment 03
-- =============================================================================
-- PREREQUISITE: Run Experiment 03's schema + sample data SQL first.
-- EXPLAIN produces an estimated query execution plan. It does not run the
-- underlying SELECT or change data. Plans may vary by MySQL version,
-- statistics, available indexes, and dataset size.

USE CompanyDB;

-- -----------------------------------------------------------------------------
-- A. EXPLAIN FOR INNER JOIN
-- Inspect table access, possible_keys, key, rows, and Extra.
-- -----------------------------------------------------------------------------
EXPLAIN
SELECT
    e.emp_name,
    d.dept_name
FROM Employee AS e
INNER JOIN Department AS d
    ON e.dept_id = d.dept_id
WHERE e.salary > 70000;

-- -----------------------------------------------------------------------------
-- B. EXPLAIN FOR CORRELATED SUBQUERY
-- Observe how MySQL plans the department-average lookup for each employee.
-- -----------------------------------------------------------------------------
EXPLAIN
SELECT
    e.emp_name,
    e.salary
FROM Employee AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employee AS e2
    WHERE e2.dept_id = e.dept_id
);

-- -----------------------------------------------------------------------------
-- C. EXPLAIN FOR EXISTS
-- Study how MySQL checks for qualifying employees in each department.
-- -----------------------------------------------------------------------------
EXPLAIN
SELECT
    d.dept_name
FROM Department AS d
WHERE EXISTS (
    SELECT 1
    FROM Employee AS e
    WHERE e.dept_id = d.dept_id
      AND e.salary > 80000
);

-- COMPARISON TIPS
-- 1. Compare "type": access method (for example, ALL, ref, eq_ref).
-- 2. Compare "possible_keys" and "key": possible versus selected indexes.
-- 3. Compare "rows": estimated rows examined by each plan step.
-- 4. Compare "Extra": supplementary execution details.
-- Do not assume a specific plan: on only 30 employees, a table scan may be
-- cheaper than an index lookup. Actual plans depend on the MySQL environment.
