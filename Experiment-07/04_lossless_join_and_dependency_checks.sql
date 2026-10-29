-- ================================================================
-- EXPERIMENT 07 | 04: LOSSLESS JOIN AND DEPENDENCY PRESERVATION
-- Prerequisite: Run scripts 01, 02 and 03 in order.
-- ================================================================
USE SalesDB;

-- Step 1: Reconstruct the original denormalized rows from the five
-- normalized relations (same fields and column order as Sales).
CREATE OR REPLACE VIEW Sales_Reconstructed AS
SELECT H.sale_id, H.sale_date, H.customer_id, C.customer_name,
       H.salesperson_id, SP.salesperson_name,
       P.product_id, P.product_name, I.quantity
FROM Sale_Header_3NF AS H
INNER JOIN Customer AS C ON H.customer_id = C.customer_id
INNER JOIN Salesperson AS SP ON H.salesperson_id = SP.salesperson_id
INNER JOIN Sale_Item AS I ON H.sale_id = I.sale_id
INNER JOIN Product AS P ON I.product_id = P.product_id;

SELECT * FROM Sales_Reconstructed ORDER BY sale_id, product_id;

-- Step 2: Count comparison from the experiment PDF (6 and 6 expected).
SELECT (SELECT COUNT(*) FROM Sales) AS original_rows,
       (SELECT COUNT(*) FROM Sales_Reconstructed) AS reconstructed_rows;

-- Step 3: Stronger comparison: rows must match in BOTH directions.
-- Compare all 9 fields, not just row counts.
-- Expected: original_rows=6, reconstructed_rows=6, missing_rows=0,
-- unexpected_rows=0.
SELECT
    (SELECT COUNT(*) FROM Sales) AS original_rows,
    (SELECT COUNT(*) FROM Sales_Reconstructed) AS reconstructed_rows,
    (
      SELECT COUNT(*)
      FROM Sales AS S
      WHERE NOT EXISTS (
          SELECT 1 FROM Sales_Reconstructed AS R
          WHERE S.sale_id = R.sale_id
            AND S.sale_date = R.sale_date
            AND S.customer_id = R.customer_id
            AND S.customer_name = R.customer_name
            AND S.salesperson_id = R.salesperson_id
            AND S.salesperson_name = R.salesperson_name
            AND S.product_id = R.product_id
            AND S.product_name = R.product_name
            AND S.quantity = R.quantity
      )
    ) AS missing_rows,
    (
      SELECT COUNT(*)
      FROM Sales_Reconstructed AS R
      WHERE NOT EXISTS (
          SELECT 1 FROM Sales AS S
          WHERE S.sale_id = R.sale_id
            AND S.sale_date = R.sale_date
            AND S.customer_id = R.customer_id
            AND S.customer_name = R.customer_name
            AND S.salesperson_id = R.salesperson_id
            AND S.salesperson_name = R.salesperson_name
            AND S.product_id = R.product_id
            AND S.product_name = R.product_name
            AND S.quantity = R.quantity
      )
    ) AS unexpected_rows;

-- Step 4: Check the three ID -> name dependencies shown in the PDF.
-- Every name_count should equal 1.
SELECT customer_id, COUNT(DISTINCT customer_name) AS name_count
FROM Customer
GROUP BY customer_id
ORDER BY customer_id;

SELECT salesperson_id, COUNT(DISTINCT salesperson_name) AS name_count
FROM Salesperson
GROUP BY salesperson_id
ORDER BY salesperson_id;

SELECT product_id, COUNT(DISTINCT product_name) AS name_count
FROM Product
GROUP BY product_id
ORDER BY product_id;

-- Step 5: Also inspect dependencies that are preserved by the keys.
-- sale_id -> sale_date, customer_id, salesperson_id
-- (sale_id, product_id) -> quantity
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header_3NF ORDER BY sale_id;

SELECT sale_id, product_id, quantity
FROM Sale_Item ORDER BY sale_id, product_id;

-- The PRIMARY KEY constraints enforce unique determinants in each
-- relation. The observed data checks alone do not prove every future
-- dataset will satisfy an FD; the declared constraints matter.
