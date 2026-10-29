-- EXPERIMENT 09: Stage 3 - Composite (train_no, journey_date) index
-- Run AFTER 03. Run ONCE per clean database setup.
USE RailwayDB;

CREATE INDEX idx_train_date ON Railway_Booking(train_no, journey_date);
ANALYZE TABLE Railway_Booking;
SHOW INDEX FROM Railway_Booking;

-- QUERY 2: Equality on BOTH indexed columns
EXPLAIN SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';

-- QUERY 1: Uses the leading (leftmost) column of the composite index.
EXPLAIN SELECT * FROM Railway_Booking WHERE train_no = 12038;
EXPLAIN ANALYZE SELECT * FROM Railway_Booking WHERE train_no = 12038;

-- QUERY 3: Date-only, does not use the leftmost column of idx_train_date.
-- A scan or a skip-scan may be chosen depending on optimizer and statistics.
EXPLAIN SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';

-- Confirm the data did not change when creating indexes.
SELECT COUNT(*) AS total_records FROM Railway_Booking;  -- 6000
SELECT COUNT(*) AS q1_train_only FROM Railway_Booking
 WHERE train_no = 12038; -- 120
SELECT COUNT(*) AS q2_train_and_date FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20'; -- 2
SELECT COUNT(*) AS q3_date_only FROM Railway_Booking
 WHERE journey_date = '2026-05-20'; -- 17

-- Optional: remove indexes if you want to test the baseline again WITHOUT
-- resetting the database. Run these manually (not part of normal execution):
-- DROP INDEX idx_train_date ON Railway_Booking;
-- DROP INDEX idx_train_no ON Railway_Booking;
