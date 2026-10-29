-- Experiment 08 | PostgreSQL | 03 - Transaction isolation
-- Run after 01 and (optionally) 02. Execute as a single pgAdmin session.

-- PostgreSQL supports READ COMMITTED, REPEATABLE READ, SERIALIZABLE,
-- and READ UNCOMMITTED (treated as READ COMMITTED).
-- BEGIN ISOLATION LEVEL makes the setting unambiguously part of the
-- transaction; SET TRANSACTION would instead be issued AFTER BEGIN.

BEGIN ISOLATION LEVEL SERIALIZABLE;
SHOW transaction_isolation;
SELECT account_id, account_holder, balance
FROM public.bank_accounts ORDER BY account_id;
COMMIT;

-- A read-only SERIALIZABLE transaction by itself does not demonstrate
-- concurrency conflicts. See files 04 and 05 for a two-session example.
