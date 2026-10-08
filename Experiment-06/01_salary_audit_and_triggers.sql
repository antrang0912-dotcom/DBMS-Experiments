-- ============================================================================
-- DBMS LAB | EXPERIMENT 06
-- Step 01: Salary audit table and salary-validation / audit triggers
-- Database: MySQL 8.0+ | Prerequisite: Experiment 03 CompanyDB
-- ============================================================================
-- Run AFTER Experiment-03/01_company_schema_and_data.sql.
-- This file may be rerun: the audit table is kept, and trigger definitions
-- are replaced. Existing audit history is NOT deleted.

USE CompanyDB;

-- 1. Store salary changes (do not erase historical entries on rerun).
CREATE TABLE IF NOT EXISTS Employee_Salary_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

-- 2. Replace triggers safely if the file is rerun.
DROP TRIGGER IF EXISTS validate_employee_salary;
DROP TRIGGER IF EXISTS validate_employee_salary_update;
DROP TRIGGER IF EXISTS audit_salary_update;

DELIMITER $$

-- Reject invalid salaries on INSERT.
CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL
       OR NEW.salary < 30000
       OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be between 30000 and 150000';
    END IF;
END$$

-- A separate BEFORE UPDATE trigger is required to validate salary updates.
CREATE TRIGGER validate_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL
       OR NEW.salary < 30000
       OR NEW.salary > 150000 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salary must be between 30000 and 150000';
    END IF;
END$$

-- Record actual salary changes only, not unrelated employee updates.
CREATE TRIGGER audit_salary_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NOT (OLD.salary <=> NEW.salary) THEN
        INSERT INTO Employee_Salary_Audit
            (emp_id, old_salary, new_salary, action)
        VALUES
            (NEW.emp_id, OLD.salary, NEW.salary, 'SALARY UPDATE');
    END IF;
END$$

DELIMITER ;

-- Verification: should list three triggers for the Employee table.
SHOW TRIGGERS FROM CompanyDB LIKE 'Employee';
