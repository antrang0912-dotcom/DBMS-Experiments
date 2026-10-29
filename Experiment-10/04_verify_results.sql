-- EXPERIMENT 10 | STEP 4: VERIFY RECORD COUNT AND QUERY SEMANTICS
-- Requires only the setup data; may run after the optimized file.
USE QueryLabDB;

SELECT COUNT(*) AS total_rows FROM EmployeeData;
SELECT department, COUNT(*) AS employee_count
FROM EmployeeData GROUP BY department ORDER BY department;

-- Query 1: YEAR predicate and date range must return the same rows.
SELECT
  (SELECT COUNT(*) FROM EmployeeData WHERE YEAR(hire_date) = 2022) AS q1_original_count,
  (SELECT COUNT(*) FROM EmployeeData
   WHERE hire_date >= '2022-01-01' AND hire_date < '2023-01-01') AS q1_rewrite_count;

-- Query 2: deliberately DIFFERENT scopes, so counts may differ.
SELECT
  (SELECT COUNT(*) FROM EmployeeData WHERE emp_name LIKE '%999%') AS substring_matches,
  (SELECT COUNT(*) FROM EmployeeData
   WHERE emp_name LIKE 'Employee!_999%' ESCAPE '!') AS prefix_matches;

-- Query 3: indexing changes performance opportunity, not query semantics.
SELECT COUNT(*) AS finance_employees
FROM EmployeeData WHERE department = 'Finance';

-- Query 4: both formulations should return the same employee IDs.
WITH old_result AS (
    SELECT e.emp_id FROM EmployeeData e
    WHERE e.salary > (
        SELECT AVG(e2.salary) FROM EmployeeData e2
        WHERE e2.department = e.department
    )
),
new_result AS (
    SELECT e.emp_id FROM EmployeeData e
    JOIN (SELECT department, AVG(salary) AS avg_salary
          FROM EmployeeData GROUP BY department) d
      ON d.department = e.department
    WHERE e.salary > d.avg_salary
)
SELECT
  (SELECT COUNT(*) FROM old_result) AS q4_old_count,
  (SELECT COUNT(*) FROM new_result) AS q4_new_count,
  (SELECT COUNT(*) FROM old_result o LEFT JOIN new_result n USING(emp_id)
   WHERE n.emp_id IS NULL) AS missing_from_rewrite,
  (SELECT COUNT(*) FROM new_result n LEFT JOIN old_result o USING(emp_id)
   WHERE o.emp_id IS NULL) AS extra_in_rewrite;

-- Query 5: OR and UNION should return the same employee IDs.
WITH old_result AS (
   SELECT emp_id FROM EmployeeData WHERE department = 'IT' OR city = 'Lucknow'
),
new_result AS (
   SELECT emp_id FROM EmployeeData WHERE department = 'IT'
   UNION
   SELECT emp_id FROM EmployeeData WHERE city = 'Lucknow'
)
SELECT
  (SELECT COUNT(*) FROM old_result) AS q5_or_count,
  (SELECT COUNT(*) FROM new_result) AS q5_union_count,
  (SELECT COUNT(*) FROM old_result o LEFT JOIN new_result n USING(emp_id)
   WHERE n.emp_id IS NULL) AS missing_from_union,
  (SELECT COUNT(*) FROM new_result n LEFT JOIN old_result o USING(emp_id)
   WHERE o.emp_id IS NULL) AS extra_in_union;
