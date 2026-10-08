-- =============================================================================
-- DBMS LAB | EXPERIMENT 05
-- Step 03: Demonstrate updatable and non-updatable views safely
-- MySQL 8.0+ | Run AFTER 01_manager_hierarchy_setup.sql and 02_views...
-- =============================================================================

USE CompanyDB;

-- ----------------------------------------------------------------------------
-- A. UPDATABLE VIEW: a straightforward, single-base-table projection.
-- Updates are executed within a transaction and then rolled back, so the
-- employee salary returns to its original value.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW employee_salary_edit AS
SELECT emp_id, emp_name, salary
FROM Employee;

START TRANSACTION;

SELECT emp_id, emp_name, salary AS salary_before
FROM Employee
WHERE emp_id = 6;

UPDATE employee_salary_edit
SET salary = salary + 1000
WHERE emp_id = 6;

SELECT emp_id, emp_name, salary AS salary_during_test
FROM Employee
WHERE emp_id = 6;

ROLLBACK;

SELECT emp_id, emp_name, salary AS salary_after_rollback
FROM Employee
WHERE emp_id = 6;

-- ----------------------------------------------------------------------------
-- B. ORIGINAL PDF'S JOINED-VIEW UPDATE TEST (run manually if desired).
-- MySQL does not reject *all* joined-view updates: updatability depends on
-- the view definition, join structure, and which underlying columns change.
-- This command is commented out to avoid a potentially surprising write.
-- If you uncomment it, test it inside a transaction and ROLLBACK afterwards.
-- ----------------------------------------------------------------------------
-- START TRANSACTION;
-- UPDATE employee_hierarchy
-- SET salary = salary + 1000
-- WHERE emp_id = 6;
-- SELECT emp_id, emp_name, salary FROM Employee WHERE emp_id = 6;
-- ROLLBACK;

-- ----------------------------------------------------------------------------
-- C. NON-UPDATABLE AGGREGATE VIEW (expected MySQL error; run separately).
-- GROUP BY + AVG produces a calculated summary, not a directly editable row.
-- This is intentionally commented so the rest of the script executes cleanly.
-- ----------------------------------------------------------------------------
-- UPDATE department_salary_summary
-- SET average_salary = average_salary + 1000
-- WHERE dept_id = 1;

-- Correct way to change an employee's salary:
-- UPDATE Employee SET salary = salary + 1000 WHERE emp_id = 6;

-- Verify that the summary view can still be read.
SELECT dept_id, dept_name, employee_count, average_salary, total_salary
FROM department_salary_summary
ORDER BY dept_id;
