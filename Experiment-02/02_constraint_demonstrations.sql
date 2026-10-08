-- ============================================================================
-- DBMS LAB | EXPERIMENT 02 - CONSTRAINT DEMONSTRATIONS
-- Run this file AFTER 01_ecommerce_schema_and_data.sql.
-- Successful deletion tests use transactions and ROLLBACK, leaving sample data
-- unchanged. Two deliberately failing INSERT statements remain commented out:
-- uncomment and run each ONE AT A TIME if you want to observe MySQL errors.
-- ============================================================================

USE EcommerceDB;

-- 1. FOREIGN KEY / REFERENTIAL INTEGRITY VIOLATION
-- CustomerID 999 does not exist. MySQL rejects the child row.
-- Expected: ERROR 1452 (Cannot add or update a child row: a foreign key
-- constraint fails). Uncomment only this line to demonstrate the violation.
-- INSERT INTO Orders (CustomerID, OrderDate, OrderStatus)
-- VALUES (999, '2026-08-19', 'Placed');

-- 2. UNIQUE CONSTRAINT VIOLATION
-- The sample data already contains sahil@example.com.
-- Expected: ERROR 1062 (Duplicate entry for a UNIQUE key).
-- INSERT INTO Customer (Name, Email, PhoneNo, DOB)
-- VALUES ('Test', 'sahil@example.com', '9000000099', '2025-01-01');

-- 3. ON DELETE SET NULL
-- Deleting SellerID = 2 sets Books.SellerID to NULL for ProductID = 3.
-- The ROLLBACK restores the original seller and book association.
START TRANSACTION;

SELECT ProductID, SellerID
FROM Books
WHERE ProductID = 3;

DELETE FROM Seller
WHERE SellerID = 2;

SELECT ProductID, SellerID
FROM Books
WHERE ProductID = 3;
-- Expected during this transaction: (ProductID = 3, SellerID = NULL)

ROLLBACK;

SELECT ProductID, SellerID
FROM Books
WHERE ProductID = 3;
-- Expected after ROLLBACK: (ProductID = 3, SellerID = 2)

-- 4. ON DELETE CASCADE
-- CustomerID = 2 owns OrderID = 2 and associated child records.
-- Deleting the customer removes their addresses, orders, order items,
-- payment and delivery rows as defined by the foreign keys.
-- ROLLBACK restores all of these records.
START TRANSACTION;

SELECT OrderID, CustomerID
FROM Orders
WHERE CustomerID = 2;

DELETE FROM Customer
WHERE CustomerID = 2;

SELECT * FROM Orders WHERE CustomerID = 2;
SELECT * FROM Address WHERE CustomerID = 2;
SELECT * FROM OrderItem WHERE OrderID = 2;
SELECT * FROM Payment WHERE OrderID = 2;
SELECT * FROM Delivery WHERE OrderID = 2;
-- Expected during this transaction: zero rows in all five results.

ROLLBACK;

SELECT OrderID, CustomerID
FROM Orders
WHERE CustomerID = 2;
-- Expected after ROLLBACK: OrderID = 2 is present again.
