# Experiment 02: ER Diagram to Relational Schema

**DBMS Lab | MySQL | Indian E-Commerce Platform**

## Aim

Convert the ER diagram into a relational schema. Write complete MySQL `CREATE TABLE` statements with primary keys, foreign keys, `NOT NULL`, `UNIQUE`, `ON DELETE CASCADE`, and `ON DELETE SET NULL` constraints. Insert sample data and demonstrate referential integrity violations.

## Overview

This experiment implements the e-commerce ER model from **Experiment 01** as a relational database. It models customers, addresses, categories, sellers, products and their specializations, orders, order items, payments, and deliveries.

### Relational schema

| Table | Primary key | Important relationships and constraints |
| --- | --- | --- |
| `Customer` | `CustomerID` | `Email` is `UNIQUE` |
| `Address` | `AddressID` | `CustomerID` references `Customer` (`CASCADE`) |
| `Category` | `CategoryID` | `CategoryName` is `UNIQUE` |
| `Seller` | `SellerID` | `PhoneNo` is `UNIQUE` |
| `Product` | `ProductID` | `CategoryID` references `Category` (`CASCADE`) |
| `Electronic` | `ProductID` | Subtype of `Product`; shared PK/FK |
| `Fashion` | `ProductID` | Subtype of `Product`; shared PK/FK |
| `Books` | `ProductID` | Subtype of `Product`; `SellerID` references `Seller` (`SET NULL`) |
| `Orders` | `OrderID` | `CustomerID` references `Customer` (`CASCADE`) |
| `OrderItem` | (`OrderID`, `ItemSeqNo`) | Composite PK; references `Orders` and `Product` (`CASCADE`) |
| `Payment` | `PaymentID` | `OrderID` is `UNIQUE` and references `Orders` (`CASCADE`) |
| `Delivery` | `DeliveryID` | `OrderID` is `UNIQUE` and references `Orders` (`CASCADE`) |

## Concepts covered

- Conversion of an ER diagram into a relational schema
- Primary keys, composite keys, and foreign keys
- `NOT NULL` and `UNIQUE` constraints
- Referential integrity and rejected invalid inserts
- `ON DELETE CASCADE` and `ON DELETE SET NULL`
- Product specialization into `Electronic`, `Fashion`, and `Books`

## Files

| File | Purpose |
| --- | --- |
| [`01_ecommerce_schema_and_data.sql`](./01_ecommerce_schema_and_data.sql) | Creates the database and 12 tables, inserts example records, and displays data |
| [`02_constraint_demonstrations.sql`](./02_constraint_demonstrations.sql) | Demonstrates constraint violations and deletion behavior |

## How to run

1. Open **MySQL Workbench** (or another MySQL 8.0+ SQL client) and connect to a MySQL server.
2. Open and execute [`01_ecommerce_schema_and_data.sql`](./01_ecommerce_schema_and_data.sql) **once on a fresh database**. It creates and uses `EcommerceDB`.
3. Inspect the results of the final `SELECT` statements.
4. Open and execute [`02_constraint_demonstrations.sql`](./02_constraint_demonstrations.sql).
5. To see a foreign-key or `UNIQUE` violation, **uncomment and run only that individual INSERT statement**. Those commands are intentionally disabled by default because MySQL rejects them.

> **Important:** The first script is designed for a fresh `EcommerceDB`. Re-running it without clearing the existing tables will produce table-already-exists errors. Avoid running it against a database containing data you need to preserve. The second script uses `START TRANSACTION` and `ROLLBACK` for its deletion examples, so successfully executed demonstrations do not permanently delete the sample data.

## Example results

After running the first script on a fresh database:

| Query | Expected result |
| --- | --- |
| `SELECT * FROM Customer;` | 2 customers: Sahil and Arjun |
| `SELECT * FROM Product;` | 3 products: laptop, shirt, and book |
| `SELECT * FROM Orders;` | 2 orders |
| `SELECT * FROM OrderItem;` | 2 order items |
| `SELECT * FROM Books;` | Book with `ProductID = 3`, `SellerID = 2` |

The constraint script demonstrates the following **expected** behavior:

| Test | Expected behavior |
| --- | --- |
| Insert an order with nonexistent `CustomerID = 999` | Rejected by a foreign key constraint |
| Insert a customer with an existing email | Rejected by `UNIQUE` constraint |
| Delete seller `2` | `Books.SellerID` becomes `NULL`, while the book remains |
| Delete customer `2` | Their address, order, order item, payment, and delivery are removed by cascading deletes |
| `ROLLBACK` after each successful deletion demonstration | Original sample data is restored |

## Notes

- This repository version is adapted from the handwritten lab experiment. It adds executable `CREATE TABLE` statements for the three product subtype tables and defines a nullable `Books.SellerID` so `ON DELETE SET NULL` can work.
- Example email addresses and phone numbers use synthetic placeholder data rather than personal contact details.
- Output descriptions above are **expected results**, not screenshots from a live MySQL execution.

## Conclusion

Converted the e-commerce ER design into MySQL relational tables and illustrated how key constraints, uniqueness, cascading deletes, and nullable foreign keys help maintain data integrity.
