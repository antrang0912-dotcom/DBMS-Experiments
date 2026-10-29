-- ================================================================
-- EXPERIMENT 07 | 01: DENORMALIZED SALES TABLE AND FIRST NORMAL FORM
-- Aim: Identify functional dependencies; demonstrate 1NF.
-- Source: Experiment_07_Antrang_Srivastava_Corrected.pdf
-- Author: Antrang Srivastava | AI/ML-2A | 25LBCS3232
-- MySQL 8.0+ | Run scripts 01 -> 02 -> 03 -> 04
-- IMPORTANT: This setup DROPS existing experiment tables in SalesDB.
-- ================================================================

CREATE DATABASE IF NOT EXISTS SalesDB;
USE SalesDB;

-- Reset only experiment-specific objects so the full sequence is repeatable.
-- Drop children before parents because later stages add foreign keys.
DROP VIEW IF EXISTS Sales_Reconstructed;
DROP TABLE IF EXISTS Sale_Item;
DROP TABLE IF EXISTS Sale_Header_3NF;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Sale_Header;
DROP TABLE IF EXISTS Sales;

-- Denormalized sale-line table (one row per product in a sale).
-- Composite PRIMARY KEY implements the candidate key identified in the PDF.
CREATE TABLE Sales (
    sale_id          INT NOT NULL,
    sale_date        DATE NOT NULL,
    customer_id      INT NOT NULL,
    customer_name    VARCHAR(50) NOT NULL,
    salesperson_id   INT NOT NULL,
    salesperson_name VARCHAR(50) NOT NULL,
    product_id       INT NOT NULL,
    product_name     VARCHAR(50) NOT NULL,
    quantity         INT NOT NULL,
    PRIMARY KEY (sale_id, product_id),
    CONSTRAINT chk_sales_quantity CHECK (quantity > 0)
);

-- Same six records as the submitted Experiment 7 PDF.
INSERT INTO Sales
(sale_id, sale_date, customer_id, customer_name,
 salesperson_id, salesperson_name, product_id, product_name, quantity)
VALUES
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 201, 'Laptop',   1),
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse',    2),
(1002, '2026-01-11', 2, 'Diya',  102, 'Priya', 201, 'Laptop',   1),
(1002, '2026-01-11', 2, 'Diya',  102, 'Priya', 203, 'Keyboard', 1),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse',    3),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 204, 'Monitor',  1);

-- 1NF: all fields contain atomic values, and each row is one sale item.
SELECT sale_id, sale_date, customer_id, customer_name,
       salesperson_id, salesperson_name,
       product_id, product_name, quantity
FROM Sales
ORDER BY sale_id, product_id;

-- Expected result: 6 rows.
SELECT COUNT(*) AS total_sales_lines FROM Sales;

-- Functional dependencies (FDs) for the sample's intended model:
-- 1. sale_id -> sale_date, customer_id, salesperson_id
-- 2. customer_id -> customer_name
-- 3. salesperson_id -> salesperson_name
-- 4. product_id -> product_name
-- 5. (sale_id, product_id) -> quantity
-- Candidate key: (sale_id, product_id).
