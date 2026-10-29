-- Experiment 08 | PostgreSQL | 01 - Database setup
-- Run in a dedicated practice database in pgAdmin 4 or psql.
-- Re-running this file deletes the old demonstration data.

DROP TABLE IF EXISTS public.bank_accounts;

CREATE TABLE public.bank_accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50) NOT NULL,
    balance NUMERIC(12, 2) NOT NULL CHECK (balance >= 0)
);

INSERT INTO public.bank_accounts (account_id, account_holder, balance)
VALUES
    (101, 'Rahul', 10000.00),
    (102, 'Aman', 5000.00);

-- Expected: Rahul = 10000.00, Aman = 5000.00; total = 15000.00
SELECT account_id, account_holder, balance
FROM public.bank_accounts
ORDER BY account_id;

SELECT SUM(balance) AS total_balance
FROM public.bank_accounts;
