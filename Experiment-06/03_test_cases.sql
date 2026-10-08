-- ============================================================================
-- DBMS LAB | EXPERIMENT 06
-- Step 03: Test valid employee transfer, salary validation, and salary audit
-- Database: MySQL 8.0+
-- ============================================================================
-- IMPORTANT: Execute on the sample CompanyDB after scripts 01 and 02.
-- This script intentionally COMMITS data changes for employee 6.
-- Run once on fresh Experiment 03 data to reproduce the expected results.
-- Intentionally failing statements are COMMENTED OUT so this file runs through.

USE CompanyDB;

-- Initial record in Experiment 03: emp_id=6, Reyansh, dept_id=1 (IT),
-- salary=62000, project_id=107.
SELECT emp_id, emp_name, dept_id, project_id, salary
FROM Employee
WHERE emp_id = 6;

-- TEST 1: Successful transfer (IT -> Marketing, dept_id 1 -> 4).
CALL transfer_employee(6, 4);

SELECT e.emp_id, e.emp_name, e.dept_id, d.dept_name
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id
WHERE e.emp_id = 6;
-- Expected on first run: 6 | Reyansh | 4 | Marketing

-- TEST 2: Transfer edge cases (execute each separately to see SQLSTATE 45000).
-- NOTE: These lines intentionally FAIL and are therefore commented out.

-- Nonexistent employee:
-- CALL transfer_employee(99, 4);
-- Expected: Employee does not exist

-- Nonexistent department:
-- CALL transfer_employee(6, 99);
-- Expected: Department does not exist

-- Employee is already in destination department:
-- CALL transfer_employee(6, 4);
-- Expected: Employee is already in this department

-- NULL ID also fails validation; a NULL employee ID matches no row:
-- CALL transfer_employee(NULL, 4);

-- TEST 3: Invalid salary UPDATE (try individually, expected failure).
-- UPDATE Employee SET salary = 20000 WHERE emp_id = 6;
-- Expected: Salary must be between 30000 and 150000

-- TEST 4: Invalid salary INSERT (also expected failure).
-- The Employee table's original six columns are named explicitly because
-- Experiment 05 might have added manager_id as a seventh column.
-- INSERT INTO Employee
--     (emp_id, emp_name, salary, hire_date, dept_id, project_id)
-- VALUES (31, 'Salary Test', 20000, '2026-09-27', 1, 101);
-- Expected: Salary must be between 30000 and 150000

-- TEST 5: Valid salary update; audit trigger writes OLD and NEW values.
-- The salary on the fresh Experiment 03 dataset changes from 62000 to 85000.
UPDATE Employee
SET salary = 85000
WHERE emp_id = 6;

SELECT emp_id, emp_name, salary
FROM Employee
WHERE emp_id = 6;

SELECT audit_id, emp_id, old_salary, new_salary, changed_at, action
FROM Employee_Salary_Audit
WHERE emp_id = 6
ORDER BY audit_id;
-- Expected on a fresh database: one audit row, 62000.00 -> 85000.00.

-- TEST 6: A department-only update must not create a salary audit entry.
-- Compare the number of audit entries before and after another run of the
-- stored procedure (on another employee) if you wish to test this manually.
-- The audit trigger's condition guards against unchanged salaries.

-- OPTIONAL: You can restore employee 6's original department and salary:
-- CALL transfer_employee(6, 1);
-- UPDATE Employee SET salary = 62000 WHERE emp_id = 6;
-- Restoration itself produces another salary audit entry (expected).
