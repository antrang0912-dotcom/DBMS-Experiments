-- ============================================================================
-- DBMS LAB | EXPERIMENT 02
-- Title : ER Diagram to Relational Schema - Indian E-Commerce Platform
-- DBMS  : MySQL 8.0+
-- Purpose: Create the schema, insert sample records, and inspect the tables.
-- Run this file FIRST, in a fresh EcommerceDB database.
-- ============================================================================

-- 1. CREATE AND SELECT DATABASE
CREATE DATABASE IF NOT EXISTS EcommerceDB;
USE EcommerceDB;

-- 2. CREATE TABLES WITH PRIMARY KEYS, FOREIGN KEYS AND CONSTRAINTS

-- Customer details
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNo VARCHAR(15) NOT NULL,
    DOB DATE NOT NULL
) ENGINE=InnoDB;

-- A customer may have multiple addresses.
-- Removing a customer also removes their stored addresses.
CREATE TABLE Address (
    AddressID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    CONSTRAINT fk_address_customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Product categories
CREATE TABLE Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
) ENGINE=InnoDB;

-- Independent sellers
CREATE TABLE Seller (
    SellerID INT AUTO_INCREMENT PRIMARY KEY,
    SellerName VARCHAR(100) NOT NULL,
    PhoneNo VARCHAR(15) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Product details
CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryID INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Image VARCHAR(255),
    CONSTRAINT fk_product_category
        FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Product specialization: Electronic, Fashion, and Books.
-- Each subtype uses ProductID as both its primary key and a foreign key.
CREATE TABLE Electronic (
    ProductID INT PRIMARY KEY,
    CONSTRAINT fk_electronic_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Fashion (
    ProductID INT PRIMARY KEY,
    CONSTRAINT fk_fashion_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- SellerID is NULLABLE because deleting a seller should SET NULL,
-- not delete the associated book.
CREATE TABLE Books (
    ProductID INT PRIMARY KEY,
    SellerID INT NULL,
    CONSTRAINT fk_books_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE,
    CONSTRAINT fk_books_seller
        FOREIGN KEY (SellerID) REFERENCES Seller(SellerID)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- Customer orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- A composite primary key identifies each item within an order.
CREATE TABLE OrderItem (
    OrderID INT NOT NULL,
    ItemSeqNo INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Unit_Price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (OrderID, ItemSeqNo),
    CONSTRAINT fk_orderitem_order
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE,
    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- UNIQUE OrderID enforces at most one payment record per order.
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    CONSTRAINT fk_payment_order
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- UNIQUE OrderID enforces at most one delivery record per order.
CREATE TABLE Delivery (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL UNIQUE,
    CourierName VARCHAR(100) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    DeliveryDate DATE,
    CONSTRAINT fk_delivery_order
        FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. INSERT SAMPLE DATA
-- Demo contact information uses placeholder values (not personal contacts).
-- Auto-increment IDs start at 1 in a fresh database.

INSERT INTO Customer (Name, Email, PhoneNo, DOB) VALUES
    ('Sahil', 'sahil@example.com', '9000000011', '2005-05-15'),
    ('Arjun', 'arjun@example.com', '9000000022', '2004-08-20');

INSERT INTO Category (CategoryName, Description) VALUES
    ('Electronics', 'Electronic products'),
    ('Fashion', 'Fashion products'),
    ('Books', 'Books');

INSERT INTO Seller (SellerName, PhoneNo) VALUES
    ('Tech Store', '9000000001'),
    ('Book Store', '9000000002');

INSERT INTO Product (CategoryID, Price, Image) VALUES
    (1, 50000.00, 'laptop.jpg'),
    (2, 999.00, 'shirt.png'),
    (3, 599.00, 'book.jpg');

INSERT INTO Electronic (ProductID) VALUES (1);
INSERT INTO Fashion (ProductID) VALUES (2);
INSERT INTO Books (ProductID, SellerID) VALUES (3, 2);

INSERT INTO Address (CustomerID, Pincode, State, City) VALUES
    (1, '208001', 'Uttar Pradesh', 'Kanpur'),
    (2, '110001', 'Delhi', 'Delhi');

INSERT INTO Orders (CustomerID, OrderDate, OrderStatus) VALUES
    (1, '2026-08-19', 'Placed'),
    (2, '2026-08-19', 'Shipped');

INSERT INTO OrderItem (OrderID, ItemSeqNo, ProductID, Quantity, Unit_Price) VALUES
    (1, 1, 1, 1, 50000.00),
    (2, 1, 2, 2, 999.00);

INSERT INTO Payment (OrderID, PaymentDate, Amount, PaymentMethod, Status) VALUES
    (1, '2026-08-19', 50000.00, 'UPI', 'Success'),
    (2, '2026-08-19', 1998.00, 'Card', 'Success');

INSERT INTO Delivery (OrderID, CourierName, Status, DeliveryDate) VALUES
    (1, 'Delhivery', 'Delivered', '2026-08-20'),
    (2, 'DTDC', 'Pending', NULL);

-- 4. VIEW SAMPLE RESULTS
SELECT * FROM Customer;
SELECT * FROM Product;
SELECT * FROM Orders;
SELECT * FROM OrderItem;
SELECT * FROM Payment;
SELECT * FROM Delivery;
SELECT * FROM Books;

-- After confirming the above, run 02_constraint_demonstrations.sql.
