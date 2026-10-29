-- EXPERIMENT 10 | STEP 1: DATABASE AND 10,000 EMPLOYEES
-- MySQL 8.0.18+ recommended (EXPLAIN ANALYZE requires 8.0.18+).
-- This script RECREATES EmployeeData. Use only on a practice database.
-- Run once, before the baseline and optimized query scripts.

CREATE DATABASE IF NOT EXISTS QueryLabDB;
USE QueryLabDB;

DROP TABLE IF EXISTS EmployeeData;
CREATE TABLE EmployeeData (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(60) NOT NULL,
    department VARCHAR(30) NOT NULL,
    salary INT NOT NULL,
    city VARCHAR(40) NOT NULL,
    hire_date DATE NOT NULL,
    performance_score DECIMAL(4,2) NOT NULL
) ENGINE=InnoDB;

SET SESSION cte_max_recursion_depth = 10001;

INSERT INTO EmployeeData
    (emp_id, emp_name, department, salary, city, hire_date, performance_score)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
SELECT
    n,
    CONCAT('Employee_', n),
    ELT((n MOD 5) + 1, 'IT', 'HR', 'Finance', 'Sales', 'Operations'),
    30000 + ((n * 137) MOD 90001),
    ELT((n MOD 6) + 1, 'Lucknow', 'Delhi', 'Mumbai', 'Pune', 'Jaipur', 'Chennai'),
    DATE_ADD('2015-01-01', INTERVAL (n MOD 3500) DAY),
    1.00 + ((n MOD 50) / 10.0)
FROM numbers;

SELECT COUNT(*) AS total_rows FROM EmployeeData; -- Expected: 10000
SELECT * FROM EmployeeData ORDER BY emp_id LIMIT 10;
SHOW INDEX FROM EmployeeData; -- At this stage only the PRIMARY index exists.
