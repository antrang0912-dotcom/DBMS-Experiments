-- Experiment 08 | PostgreSQL | 02 - COMMIT, ROLLBACK and SAVEPOINT
-- Prerequisite: run 01_create_bank_accounts.sql once.
-- Run this entire file once, in order, to reproduce the expected results.

-- A. BEGIN + COMMIT: transfer INR 2000 from Rahul (101) to Aman (102).
BEGIN;
UPDATE public.bank_accounts
SET balance = balance - 2000.00
WHERE account_id = 101;
UPDATE public.bank_accounts
SET balance = balance + 2000.00
WHERE account_id = 102;
COMMIT;

-- Expected: 101 = 8000.00, 102 = 7000.00, total = 15000.00.
SELECT 'after_commit' AS stage, account_id, account_holder, balance
FROM public.bank_accounts ORDER BY account_id;

-- B. ROLLBACK: attempt to withdraw INR 1000, then cancel.
BEGIN;
UPDATE public.bank_accounts
SET balance = balance - 1000.00
WHERE account_id = 101;

-- Within this transaction, 101 temporarily shows 7000.00.
SELECT 'before_rollback' AS stage, account_id, account_holder, balance
FROM public.bank_accounts ORDER BY account_id;
ROLLBACK;

-- Expected: 101 restored to 8000.00; 102 remains 7000.00.
SELECT 'after_rollback' AS stage, account_id, account_holder, balance
FROM public.bank_accounts ORDER BY account_id;

-- C. SAVEPOINT: keep a valid INR 500 transfer but undo an extra debit.
BEGIN;
UPDATE public.bank_accounts
SET balance = balance - 500.00
WHERE account_id = 101;
SAVEPOINT sp1;

-- Demonstrate partial reversal with a VALID extra debit so the script
-- executes from start to finish without deliberately raising an error.
UPDATE public.bank_accounts
SET balance = balance - 1000.00
WHERE account_id = 101;
SELECT 'before_savepoint_rollback' AS stage, account_id, balance
FROM public.bank_accounts ORDER BY account_id;

ROLLBACK TO SAVEPOINT sp1;
UPDATE public.bank_accounts
SET balance = balance + 500.00
WHERE account_id = 102;
RELEASE SAVEPOINT sp1;
COMMIT;

-- Expected: 101 = 7500.00, 102 = 7500.00; sum = 15000.00.
SELECT 'after_savepoint_commit' AS stage, account_id, account_holder, balance
FROM public.bank_accounts ORDER BY account_id;
SELECT SUM(balance) AS total_balance_after_transactions
FROM public.bank_accounts;

-- The PDF also shows an intentionally invalid debit of INR 20000.
-- That violates CHECK(balance >= 0) and causes an SQL error in PostgreSQL.
-- It is excluded from this runnable script so all examples can complete.
-- For a supervised error demonstration, replace the extra -1000.00 debit
-- above with -20000.00, execute the statements individually, and then
-- issue ROLLBACK TO SAVEPOINT sp1 before proceeding.
