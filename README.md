# 🗄️ Database Management Systems (DBMS) Lab Experiments

![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?style=flat-square&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-336791?style=flat-square)
![Experiments](https://img.shields.io/badge/Experiments-06_Completed-2E8B57?style=flat-square)
![GitHub](https://img.shields.io/badge/Platform-GitHub-181717?style=flat-square&logo=github)

A well-organized collection of **Database Management Systems (DBMS) lab experiments**, covering database design, relational schemas, SQL queries, joins, views, stored procedures, triggers, and transaction handling using **MySQL**.

Each experiment has its own folder with a detailed `README.md`, SQL scripts where applicable, and clear execution instructions.

---

## 📚 Experiment Index

| No. | Experiment | Key Concepts | Files |
|:---:|---|---|---|
| **01** | [ER Diagram for an E-Commerce Platform](./Experiment-01/) | Entities, attributes, relationships, keys, specialization | PDF + README |
| **02** | [ER Diagram to Relational Schema](./Experiment-02/) | `CREATE TABLE`, PK, FK, `UNIQUE`, `NOT NULL`, `CASCADE`, `SET NULL` | SQL + README |
| **03** | [Employee–Department–Project Database](./Experiment-03/) | Selection, projection, aggregates, `GROUP BY`, `HAVING`, `CASE`, `ORDER BY` | SQL + README |
| **04** | [SQL JOINs, Subqueries & EXPLAIN](./Experiment-04/) | `INNER JOIN`, `LEFT JOIN`, self-join, correlated subqueries, `EXISTS` | SQL + README |
| **05** | [SQL Views & Recursive CTE](./Experiment-05/) | Views, view updatability, employee hierarchy, recursive reporting chains | SQL + README |
| **06** | [Stored Procedures, Triggers & Audit Logging](./Experiment-06/) | Procedures, salary validation, audit logs, transactions, error handling | SQL + README |

> **Note:** Experiment 01 includes the original ER diagram as a PDF. Experiments 02–06 are provided as readable and reusable SQL scripts.

## 🧠 Concepts Covered

- **Database design:** ER diagrams, relational schemas, primary keys, and foreign keys
- **SQL fundamentals:** DDL, DML, filtering, sorting, grouping, and aggregate functions
- **Advanced queries:** Joins, nested queries, `EXISTS`, and `EXPLAIN`
- **Database programming:** Views, recursive CTEs, stored procedures, and triggers
- **Data integrity:** Constraints, cascading actions, validation, transactions, and audit logging

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| **MySQL 8.0+** | Relational database management system |
| **SQL** | Database creation, manipulation, and querying |
| **MySQL Workbench** | Writing and executing SQL scripts |
| **Git & GitHub** | Version control and experiment documentation |

## 📁 Repository Structure

```text
DBMS-Experiments/
├── Experiment-01/    # E-commerce ER diagram (PDF)
├── Experiment-02/    # Relational schema and constraints
├── Experiment-03/    # CompanyDB setup and SQL queries
├── Experiment-04/    # JOINs, subqueries, and EXPLAIN
├── Experiment-05/    # Views and recursive CTEs
├── Experiment-06/    # Procedures, triggers, and audit logging
└── README.md         # Repository overview (this file)
```

Each experiment folder includes its own **README** with the aim, topics covered, relevant files, and instructions.

## 🚀 How to Run the Experiments

1. Install **MySQL 8.0+** and a SQL client such as **MySQL Workbench**.
2. Clone this repository, or download it using **Code → Download ZIP**:

   ```bash
   git clone https://github.com/antrang0912-dotcom/DBMS-Experiments.git
   ```

3. Open the required `.sql` file in MySQL Workbench using **File → Open SQL Script**.
4. Execute the scripts in the order described in that experiment's `README.md`.

### Database Setup & Dependencies

- **Experiment 01:** Open the ER diagram PDF; no SQL execution is required.
- **Experiment 02:** Creates and uses its own e-commerce database, `EcommerceDB`.
- **Experiment 03:** Creates and populates `CompanyDB` with **30 employees, 5 departments, and 8 projects**.
- **Experiment 04:** Uses the `CompanyDB` tables and data created in Experiment 03.
- **Experiment 05:** Uses `CompanyDB`; run its numbered SQL files in order (`01 → 02 → 03`).
- **Experiment 06:** Uses `CompanyDB`; run its numbered SQL files in order (`01 → 02 → 03`).

> ⚠️ **Important:** Some scripts demonstrate updates, deletes, transactions, and intentionally invalid operations. Read the experiment-specific README before executing them, and use a practice database instead of production data.

## 🎯 Learning Outcomes

By completing these experiments, you can understand how relational databases are designed, implement SQL constraints, retrieve and analyze data, build reusable views, traverse employee hierarchies, and enforce business rules through procedures and triggers.

---

## 👨‍💻 Author

**Antrang Srivastava**  
B.Tech — Computer Science & Engineering (AI & ML)  
Chandigarh University

*Developed as part of DBMS laboratory coursework.*
