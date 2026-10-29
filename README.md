🗄️ Database Management Systems — Lab Experiments
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Experiment%2008-4169E1?logo=postgresql&logoColor=white)
![Experiments](https://img.shields.io/badge/Experiments-10%20Prepared-brightgreen)
![SQL](https://img.shields.io/badge/Language-SQL-informational)
An organized collection of ten DBMS laboratory experiments, from ER diagrams and relational design to transactions, indexing, and query optimization. Each experiment is grouped with SQL scripts (where applicable) and documentation.
📚 Experiment Index
No.	Experiment	Key Concepts	Contents
01	E-Commerce ER Diagram	Entities, keys, attributes, relationships	ER diagram + README
02	Relational Schema & Integrity	PK, FK, UNIQUE, NOT NULL, referential actions	SQL + README
03	Employee–Department–Project Database	SELECT, aggregates, GROUP BY, HAVING	SQL + README
04	Joins, Subqueries & EXPLAIN	INNER/LEFT/SELF JOIN, EXISTS, subqueries	SQL + README
05	Views & Recursive CTE	Views, reporting hierarchy, recursion	SQL + README
06	Stored Procedures & Triggers	Procedures, validation, audit logs	SQL + README
07	Database Normalization	1NF, 2NF, 3NF, BCNF, lossless join	SQL + README
08	Banking Transactions & Concurrency	BEGIN, COMMIT, ROLLBACK, SAVEPOINT, ACID	SQL + README
09	Railway Booking Indexing & Performance	Single/composite indexes, EXPLAIN ANALYZE	SQL + README
10	SQL Query Optimization	10,000 rows, five query cases, indexing, rewriting	SQL + README
🛠️ Technology Stack
Technology	Use
MySQL 8.0+	Main relational database for most exercises (10 uses 8.0.18+ for EXPLAIN ANALYZE)
PostgreSQL	Experiment 08 transaction and two-session concurrency demonstrations
SQL	DDL, DML, querying, transactions, schema constraints, and tuning
MySQL Workbench / pgAdmin / SQL CLI	Running and inspecting the SQL code
GitHub	Version control and documentation
📁 Repository Layout
```text
DBMS-Experiments/
├── Experiment-01/
├── Experiment-02/
├── Experiment-03/
├── Experiment-04/
├── Experiment-05/
├── Experiment-06/
├── Experiment-07/
├── Experiment-08/
├── Experiment-09/
├── Experiment-10/
└── README.md
```
🚀 Run Locally
Download via Code → Download ZIP, or clone this repository.
Open the relevant `Experiment-XX/README.md` first to check the DBMS and prerequisites.
Run that experiment's numbered SQL scripts in order on a practice database.
Some experiments depend on prior setup: Experiments 04, 05, and 06 use `CompanyDB` from Experiment 03.
Experiments 07, 09, and 10 use their own MySQL databases. Experiment 08 requires PostgreSQL, and its concurrency steps require two separate sessions.
Query timings and optimizer plans may differ by system; sample output is not a guarantee of a measured speedup.
🎯 Learning Outcomes
Design ER models and normalized relational schemas.
Enforce data integrity with keys and constraints.
Use joins, grouping, subqueries, views, and recursive CTEs.
Implement procedures, triggers, audit logs, and transaction safety.
Investigate indexing and query plans, and explain optimization trade-offs.
👨‍💻 Author
Antrang Srivastava  
AI/ML-2A · 25LBCS3232  
B.Tech — Computer Science & Engineering (AI & ML)  
Chandigarh University
Developed as part of DBMS laboratory coursework.
