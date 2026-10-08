-- =============================================================================
-- DBMS LAB | EXPERIMENT 05
-- Step 01: Add manager relationships to the existing CompanyDB Employee table
-- MySQL 8.0+ | Depends on Experiment 03
-- =============================================================================
-- PREREQUISITE: Run Experiment-03/01_company_schema_and_data.sql once.
-- IMPORTANT: Run this migration only ONCE. It adds a manager_id column.
-- The Experiment 05 source describes manager_id but does not provide the
-- ALTER TABLE or manager assignment statements. The assignments below are
-- demonstration data consistent with the reporting chains shown in the PDF.

USE CompanyDB;

-- Add a self-referencing foreign key for reporting relationships.
-- A department head has manager_id = NULL.
ALTER TABLE Employee
    ADD COLUMN manager_id INT NULL;

ALTER TABLE Employee
    ADD CONSTRAINT fk_employee_manager
    FOREIGN KEY (manager_id)
    REFERENCES Employee (emp_id)
    ON DELETE SET NULL;

-- Fill in example reporting relationships across all five departments.
-- Department heads: Aarav (IT), Ananya (HR), Nikhil (Finance),
-- Aanya (Marketing), and Rudra (Operations).
UPDATE Employee
SET manager_id = CASE emp_id
    -- IT (dept_id = 1)
    WHEN 1 THEN NULL       -- Aarav, department head
    WHEN 2 THEN 1          -- Vivaan -> Aarav
    WHEN 3 THEN 1          -- Aditya -> Aarav
    WHEN 4 THEN 2          -- Arjun -> Vivaan
    WHEN 5 THEN 2          -- Kabir -> Vivaan
    WHEN 6 THEN 3          -- Reyansh -> Aditya

    -- HR (dept_id = 2)
    WHEN 7 THEN NULL       -- Ananya, department head
    WHEN 8 THEN 7          -- Diya -> Ananya
    WHEN 9 THEN 7          -- Myra -> Ananya
    WHEN 10 THEN 8         -- Sara -> Diya
    WHEN 11 THEN 8         -- Ishita -> Diya
    WHEN 12 THEN 7         -- Meera -> Ananya

    -- Finance (dept_id = 3)
    WHEN 13 THEN 15        -- Rohan -> Nikhil
    WHEN 14 THEN 13        -- Karan -> Rohan
    WHEN 15 THEN NULL      -- Nikhil, department head
    WHEN 16 THEN 14        -- Yash -> Karan
    WHEN 17 THEN 13        -- Manav -> Rohan
    WHEN 18 THEN 16        -- Dev -> Yash

    -- Marketing (dept_id = 4)
    WHEN 19 THEN NULL      -- Aanya, department head
    WHEN 20 THEN 19        -- Kiara -> Aanya
    WHEN 21 THEN 19        -- Tanya -> Aanya
    WHEN 22 THEN 20        -- Riya -> Kiara
    WHEN 23 THEN 20        -- Avni -> Kiara
    WHEN 24 THEN 22        -- Navya -> Riya

    -- Operations (dept_id = 5)
    WHEN 25 THEN 29        -- Samar -> Rudra
    WHEN 26 THEN 29        -- Dhruv -> Rudra
    WHEN 27 THEN 26        -- Atharv -> Dhruv
    WHEN 28 THEN 25        -- Parth -> Samar
    WHEN 29 THEN NULL      -- Rudra, department head
    WHEN 30 THEN 28        -- Veer -> Parth
    ELSE NULL
END;

-- Verification: 30 employees, 5 department heads, 25 reporting employees.
SELECT
    COUNT(*) AS total_employees,
    SUM(manager_id IS NULL) AS department_heads,
    SUM(manager_id IS NOT NULL) AS reporting_employees
FROM Employee;

-- Review employee -> manager IDs (names appear in the hierarchy view).
SELECT emp_id, emp_name, dept_id, manager_id
FROM Employee
ORDER BY dept_id, emp_id;
