-- EXPERIMENT 10 | STEP 3: AFTER OPTIMIZATION
-- Prerequisite: baseline collected with 02_baseline_five_queries.sql.
-- Rerun 01 setup before repeating the whole experiment to avoid duplicate-index errors.
USE QueryLabDB;

-- Query 1: indexed date range, equivalent to YEAR(hire_date) = 2022.
CREATE INDEX idx_hire_date ON EmployeeData(hire_date);
EXPLAIN SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE hire_date >= '2022-01-01' AND hire_date < '2023-01-01';
EXPLAIN ANALYZE SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE hire_date >= '2022-01-01' AND hire_date < '2023-01-01';

-- Query 2: named prefix search, indexed. IMPORTANT: different requirement!
-- The original '%999%' matches a substring anywhere; this prefix only
-- matches names starting with the literal characters 'Employee_999'.
-- '!' is the escape character so '_' is literal rather than a SQL wildcard.
CREATE INDEX idx_emp_name ON EmployeeData(emp_name);
EXPLAIN SELECT emp_id, emp_name FROM EmployeeData
WHERE emp_name LIKE 'Employee!_999%' ESCAPE '!';
EXPLAIN ANALYZE SELECT emp_id, emp_name FROM EmployeeData
WHERE emp_name LIKE 'Employee!_999%' ESCAPE '!';

-- Query 3: index on department. Low selectivity means a full scan may
-- STILL be chosen by MySQL; do not assume the index always wins.
CREATE INDEX idx_department ON EmployeeData(department);
EXPLAIN SELECT emp_id, emp_name, salary
FROM EmployeeData WHERE department = 'Finance';
EXPLAIN ANALYZE SELECT emp_id, emp_name, salary
FROM EmployeeData WHERE department = 'Finance';

-- Query 4: calculate department averages in a grouped derived table.
CREATE INDEX idx_department_salary ON EmployeeData(department, salary);
EXPLAIN SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData AS e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM EmployeeData GROUP BY department
) AS d ON d.department = e.department
WHERE e.salary > d.avg_salary;
EXPLAIN ANALYZE SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData AS e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM EmployeeData GROUP BY department
) AS d ON d.department = e.department
WHERE e.salary > d.avg_salary;

-- Query 5: UNION removes duplicates, matching OR's distinct result rows.
-- Performance is data/optimizer dependent; UNION may be slower than OR.
CREATE INDEX idx_city ON EmployeeData(city);
EXPLAIN SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE department = 'IT'
UNION
SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE city = 'Lucknow';
EXPLAIN ANALYZE SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE department = 'IT'
UNION
SELECT emp_id, emp_name, department, city
FROM EmployeeData WHERE city = 'Lucknow';

SHOW INDEX FROM EmployeeData;
-- Record the actual AFTER times (do not invent timings).
