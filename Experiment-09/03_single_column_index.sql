-- EXPERIMENT 09: Stage 2 - Index on train_no
-- Run AFTER 02. Run ONCE per clean database setup.
USE RailwayDB;

CREATE INDEX idx_train_no ON Railway_Booking(train_no);
ANALYZE TABLE Railway_Booking;
SHOW INDEX FROM Railway_Booking;

-- QUERY 1: Train number only
EXPLAIN SELECT * FROM Railway_Booking WHERE train_no = 12038;
EXPLAIN ANALYZE SELECT * FROM Railway_Booking WHERE train_no = 12038;

-- QUERY 2: Train number + journey date
EXPLAIN SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20';

-- QUERY 3: Date-only; idx_train_no does not directly help this filter.
EXPLAIN SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';
EXPLAIN ANALYZE SELECT * FROM Railway_Booking
 WHERE journey_date = '2026-05-20';

-- IMPORTANT: optimizer may choose 'ALL' rather than 'ref'. This is valid.
-- Record the actual plan, not a predetermined improvement.
