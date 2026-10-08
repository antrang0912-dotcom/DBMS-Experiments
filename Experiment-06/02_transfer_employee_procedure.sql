-- ============================================================================
-- DBMS LAB | EXPERIMENT 06
-- Step 02: Transfer employee stored procedure, with validation and rollback
-- Database: MySQL 8.0+
-- ============================================================================
-- Prerequisite: Employee and Department tables from Experiment 03.
-- Run this AFTER 01_salary_audit_and_triggers.sql.
-- Rerunning replaces the stored procedure but does not change employee data.

USE CompanyDB;

DROP PROCEDURE IF EXISTS transfer_employee;

DELIMITER $$

CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE v_emp_count INT DEFAULT 0;
    DECLARE v_dept_count INT DEFAULT 0;
    DECLARE v_old_dept_id INT DEFAULT NULL;

    -- Roll back the transaction and pass the original SQL error to the caller.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Validate employee ID.
    SELECT COUNT(*) INTO v_emp_count
    FROM Employee
    WHERE emp_id = p_emp_id;

    IF v_emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee does not exist';
    END IF;

    -- Validate destination department ID.
    SELECT COUNT(*) INTO v_dept_count
    FROM Department
    WHERE dept_id = p_new_dept_id;

    IF v_dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department does not exist';
    END IF;

    -- Lock the employee row while checking and updating the department.
    SELECT dept_id INTO v_old_dept_id
    FROM Employee
    WHERE emp_id = p_emp_id
    FOR UPDATE;

    IF v_old_dept_id <=> p_new_dept_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Employee is already in this department';
    END IF;

    -- This follows the lab's definition: only dept_id changes.
    -- A real HR application may also reassign the employee's project/manager.
    UPDATE Employee
    SET dept_id = p_new_dept_id
    WHERE emp_id = p_emp_id;

    COMMIT;
END$$

DELIMITER ;

-- Confirm that the procedure exists.
SHOW CREATE PROCEDURE transfer_employee;
