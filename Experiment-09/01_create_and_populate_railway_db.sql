-- EXPERIMENT 09: Railway Booking - Database setup and sample data
-- DBMS: MySQL 8.0.18+ (EXPLAIN ANALYZE), InnoDB
-- Student: Antrang Srivastava | AI/ML-2A | 25LBCS3232
-- Run FIRST. WARNING: Re-running this script resets Railway_Booking.

CREATE DATABASE IF NOT EXISTS RailwayDB;
USE RailwayDB;

-- Remove only this experiment's table to produce a repeatable dataset.
DROP TABLE IF EXISTS Railway_Booking;

CREATE TABLE Railway_Booking (
    booking_id INT PRIMARY KEY,
    passenger_name VARCHAR(50) NOT NULL,
    train_no INT NOT NULL,
    source_station VARCHAR(30) NOT NULL,
    destination_station VARCHAR(30) NOT NULL,
    journey_date DATE NOT NULL,
    travel_class VARCHAR(5),
    seat_no INT,
    fare DECIMAL(8,2),
    booking_status VARCHAR(15)
) ENGINE=InnoDB;

-- Default recursive CTE depth is usually 1000; 6000 rows need a higher limit.
SET SESSION cte_max_recursion_depth = 10000;

-- Dataset/formulas reproduced from the supplied Experiment 09 PDF.
-- For MySQL INSERT ... WITH RECURSIVE, place WITH after INSERT INTO (...).
INSERT INTO Railway_Booking
    (booking_id, passenger_name, train_no, source_station,
     destination_station, journey_date, travel_class,
     seat_no, fare, booking_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 6000
)
SELECT
    n,
    CONCAT('Passenger_', n),
    12000 + MOD(n * 7, 50),
    ELT(MOD(n, 10) + 1,
        'Delhi', 'Mumbai', 'Kolkata', 'Chennai', 'Lucknow',
        'Kanpur', 'Jaipur', 'Bhopal', 'Patna', 'Ahmedabad'),
    ELT(MOD(n * 3 + 1, 10) + 1,
        'Delhi', 'Mumbai', 'Kolkata', 'Chennai', 'Lucknow',
        'Kanpur', 'Jaipur', 'Bhopal', 'Patna', 'Ahmedabad'),
    DATE_ADD('2026-01-01', INTERVAL MOD(n, 365) DAY),
    ELT(MOD(FLOOR(n / 7), 5) + 1, 'SL', '3A', '2A', '1A', 'CC'),
    1 + MOD(n * 11, 72),
    300 + MOD(n * 37, 2700),
    ELT(MOD(FLOOR(n / 3), 3) + 1, 'Confirmed', 'Waiting', 'Cancelled')
FROM seq;

-- Verify original PDF requirements and inspect data.
SELECT COUNT(*) AS total_records FROM Railway_Booking; -- expected: 6000
SELECT * FROM Railway_Booking ORDER BY booking_id LIMIT 5;
SELECT COUNT(DISTINCT train_no) AS distinct_trains,
       COUNT(DISTINCT journey_date) AS distinct_dates,
       COUNT(DISTINCT source_station) AS distinct_sources,
       COUNT(DISTINCT travel_class) AS distinct_classes,
       COUNT(DISTINCT booking_status) AS distinct_statuses
FROM Railway_Booking;

-- Check that each benchmark filter actually matches data:
SELECT COUNT(*) AS rows_for_train FROM Railway_Booking WHERE train_no = 12038; -- 120
SELECT COUNT(*) AS rows_for_train_and_date FROM Railway_Booking
 WHERE train_no = 12038 AND journey_date = '2026-05-20'; -- 2
SELECT COUNT(*) AS rows_for_date FROM Railway_Booking
 WHERE journey_date = '2026-05-20'; -- 17
