-- Core analytical query: average fare, average trip duration,
-- and trip count grouped by borough
SELECT
  clean_trips.borough,
  AVG(clean_trips.fare_amount) AS avg_fare,
  AVG(clean_trips.trip_duration_minutes) AS avg_trip_duration,
  COUNT(*) AS trip_count
FROM tlc_borough_analytics.clean_trips
GROUP BY clean_trips.Borough
ORDER BY trip_count DESC
