-- Experiment 08 | PostgreSQL | 05 - Session 2 (MANUAL TWO-WINDOW DEMO)
-- Do NOT run this whole script at once.
-- Begin AFTER Session 1 has executed PHASE 1 (the uncommitted UPDATE).

-- PHASE 2: Run these statements in Session 2.
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT balance AS balance_before_session_1_commit
FROM public.bank_accounts
WHERE account_id = 101;
-- Expected 7500.00 after file 02: no dirty read of uncommitted 9000.00.
-- STOP HERE. Keep this transaction open; DO NOT COMMIT YET.

-- PHASE 4: After Session 1 commits, run in the SAME open Session 2 transaction:
SELECT balance AS balance_after_session_1_commit
FROM public.bank_accounts
WHERE account_id = 101;
-- Expected: 9000.00. The value changed between two SELECTs within
-- the same READ COMMITTED transaction (non-repeatable read).
COMMIT;

-- If you need to repeat, restore data using 01 then 02 and start again.
