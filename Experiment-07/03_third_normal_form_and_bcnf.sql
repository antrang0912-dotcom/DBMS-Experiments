-- ================================================================
-- EXPERIMENT 07 | 03: THIRD NORMAL FORM (3NF) AND BCNF
-- Prerequisite: Run scripts 01 and 02 first.
-- ================================================================
USE SalesDB;

-- Remove transitive dependencies from the 2NF Sale_Header.
CREATE TABLE Customer (
    customer_id   INT NOT NULL PRIMARY KEY,
    customer_name VARCHAR(50) NOT NULL
);
INSERT INTO Customer (customer_id, customer_name)
SELECT DISTINCT customer_id, customer_name FROM Sale_Header;

CREATE TABLE Salesperson (
    salesperson_id   INT NOT NULL PRIMARY KEY,
    salesperson_name VARCHAR(50) NOT NULL
);
INSERT INTO Salesperson (salesperson_id, salesperson_name)
SELECT DISTINCT salesperson_id, salesperson_name FROM Sale_Header;

-- Final 3NF sale header references customer and salesperson master tables.
CREATE TABLE Sale_Header_3NF (
    sale_id        INT NOT NULL PRIMARY KEY,
    sale_date      DATE NOT NULL,
    customer_id    INT NOT NULL,
    salesperson_id INT NOT NULL,
    CONSTRAINT fk_3nf_customer FOREIGN KEY (customer_id)
        REFERENCES Customer (customer_id),
    CONSTRAINT fk_3nf_salesperson FOREIGN KEY (salesperson_id)
        REFERENCES Salesperson (salesperson_id)
);
INSERT INTO Sale_Header_3NF (sale_id, sale_date, customer_id, salesperson_id)
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header;

-- Link the existing Sale_Item table to the final 3NF header as well.
-- Its original 2NF FK remains to preserve the intermediate demonstration.
ALTER TABLE Sale_Item
    ADD CONSTRAINT fk_item_3nf_header FOREIGN KEY (sale_id)
    REFERENCES Sale_Header_3NF (sale_id);

-- Five final logical relations:
-- Customer, Salesperson, Product, Sale_Header_3NF and Sale_Item.
SELECT * FROM Customer ORDER BY customer_id;
SELECT * FROM Salesperson ORDER BY salesperson_id;
SELECT * FROM Product ORDER BY product_id;
SELECT * FROM Sale_Header_3NF ORDER BY sale_id;
SELECT * FROM Sale_Item ORDER BY sale_id, product_id;

SELECT (SELECT COUNT(*) FROM Customer) AS customers,
       (SELECT COUNT(*) FROM Salesperson) AS salespersons,
       (SELECT COUNT(*) FROM Product) AS products,
       (SELECT COUNT(*) FROM Sale_Header_3NF) AS sale_headers,
       (SELECT COUNT(*) FROM Sale_Item) AS sale_items;

-- BCNF assessment under the FDs stated in the lab PDF:
-- Customer:         customer_id -> customer_name
-- Salesperson:      salesperson_id -> salesperson_name
-- Product:          product_id -> product_name
-- Sale_Header_3NF:  sale_id -> sale_date, customer_id, salesperson_id
-- Sale_Item:        (sale_id, product_id) -> quantity
-- Each determinant is a candidate key in its relation, so these
-- final five relations satisfy BCNF under those FDs.
-- SQL keys enforce identifier uniqueness; BCNF is a schema/FD property.
