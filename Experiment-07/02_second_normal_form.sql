-- ================================================================
-- EXPERIMENT 07 | 02: SECOND NORMAL FORM (2NF)
-- Prerequisite: Run 01_sales_database_and_1nf.sql first.
-- ================================================================
USE SalesDB;

-- Remove partial dependencies of the composite key (sale_id, product_id):
-- sale_id determines sale-level fields; product_id determines product_name.
-- The resulting 2NF relations are Sale_Header, Product and Sale_Item.

CREATE TABLE Sale_Header (
    sale_id          INT NOT NULL PRIMARY KEY,
    sale_date        DATE NOT NULL,
    customer_id      INT NOT NULL,
    customer_name    VARCHAR(50) NOT NULL,
    salesperson_id   INT NOT NULL,
    salesperson_name VARCHAR(50) NOT NULL
);
INSERT INTO Sale_Header
(sale_id, sale_date, customer_id, customer_name,
 salesperson_id, salesperson_name)
SELECT DISTINCT sale_id, sale_date, customer_id, customer_name,
                salesperson_id, salesperson_name
FROM Sales;

CREATE TABLE Product (
    product_id   INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL
);
INSERT INTO Product (product_id, product_name)
SELECT DISTINCT product_id, product_name FROM Sales;

CREATE TABLE Sale_Item (
    sale_id    INT NOT NULL,
    product_id INT NOT NULL,
    quantity   INT NOT NULL,
    PRIMARY KEY (sale_id, product_id),
    CONSTRAINT fk_item_2nf_header FOREIGN KEY (sale_id)
        REFERENCES Sale_Header (sale_id),
    CONSTRAINT fk_item_product FOREIGN KEY (product_id)
        REFERENCES Product (product_id),
    CONSTRAINT chk_item_quantity CHECK (quantity > 0)
);
INSERT INTO Sale_Item (sale_id, product_id, quantity)
SELECT sale_id, product_id, quantity FROM Sales;

-- Expected: 3 sale headers, 4 products and 6 sale items.
SELECT * FROM Sale_Header ORDER BY sale_id;
SELECT * FROM Product ORDER BY product_id;
SELECT * FROM Sale_Item ORDER BY sale_id, product_id;

SELECT (SELECT COUNT(*) FROM Sale_Header) AS sale_headers,
       (SELECT COUNT(*) FROM Product) AS products,
       (SELECT COUNT(*) FROM Sale_Item) AS sale_items;

-- NOTE: 2NF Sale_Header still has transitive dependencies:
-- customer_id -> customer_name and salesperson_id -> salesperson_name.
