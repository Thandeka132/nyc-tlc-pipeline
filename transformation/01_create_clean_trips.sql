-- Creates the clean_trips table: joins raw_trips with dim_zones,
-- adds Borough and trip_duration_minutes
CREATE OR REPLACE TABLE tlc_borough_analytics.clean_trips AS (
SELECT
  raw_trips.tpep_pickup_datetime,
  raw_trips.tpep_dropoff_datetime,
  TIMESTAMP_DIFF(raw_trips.tpep_dropoff_datetime, raw_trips.tpep_pickup_datetime, MINUTE) AS trip_duration_minutes,
  raw_trips.fare_amount,
  raw_trips.trip_distance,
  raw_trips.passenger_count,
  raw_trips.PULocationID,
  dim_zones.Borough
FROM tlc_borough_analytics.raw_trips
INNER JOIN tlc_borough_analytics.dim_zones
  ON raw_trips.PULocationID = dim_zones.LocationID
);
