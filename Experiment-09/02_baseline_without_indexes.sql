-- EXPERIMENT 09: Stage 1 - Before secondary indexes
-- Run AFTER 01 and BEFORE 03 or 04, in the RailwayDB database.
USE RailwayDB;

-- On a fresh run, only the PRIMARY index on booking_id should exist.
SHOW INDEX FROM Railway_Booking;
ANALYZE TABLE Railway_Booking;

-- QUERY 1: Train number only
SELECT * FROM Railway_Booking WHERE train_no = 12038;
EXPLAIN SELECT * FROM Railway_Booking WHERE train_no = 12038;
EXPLAIN ANALYZE SELECT * FROM Railway_Booking WHERE train_no = 12038;

-- QUERY 2: Train number + journey date
SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';
EXPLAIN SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';

-- QUERY 3: Date-only (extra baseline comparison)
SELECT * FROM Railway_Booking WHERE journey_date = '2026-05-20';
EXPLAIN SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';

-- Save access type, key, estimated rows, and EXPLAIN ANALYZE actual time
-- to the README comparison table. Times differ across computers.
