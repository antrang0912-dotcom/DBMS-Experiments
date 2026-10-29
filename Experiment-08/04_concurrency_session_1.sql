-- Experiment 08 | PostgreSQL | 04 - Session 1 (MANUAL TWO-WINDOW DEMO)
-- Do NOT run this whole script at once.
-- Follow the numbered phases in README.md and file 05.
-- Run setup (01) and main transactions (02) BEFORE starting this demo.
-- Expected initial account 101 balance after 02: 7500.00.

-- PHASE 1: Run ONLY these statements in Session 1, leave uncommitted:
BEGIN;
UPDATE public.bank_accounts
SET balance = 9000.00
WHERE account_id = 101;
-- STOP HERE. Keep this transaction open.

-- PHASE 3: After Session 2 completes its FIRST SELECT, run:
COMMIT;

-- The change to 9000.00 is an isolated concurrency demonstration,
-- not a money transfer; it deliberately changes the total balance.
-- To restore initial demo values, rerun 01 and then 02.
