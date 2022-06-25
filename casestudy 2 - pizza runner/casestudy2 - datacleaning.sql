-- 8 Week SQL Challenge by Dany Ma
-- Case study 2: Pizza runner
-- https://8weeksqlchallenge.com/case-study-2/ 

-- Coded by Marian Eerens in Google BigQuery
-- https://github.com/meerens/8-week-sqlchallenge

-- Cleaning data: customer_orders table --
-- Replacing all 'unvalid' values with nulls

CREATE OR REPLACE TABLE sqlchallenge_week2.customer_orders_c AS
SELECT
order_id,
customer_id,
pizza_id,
  CASE
  WHEN exclusions LIKE '%null%' OR exclusions LIKE '' THEN NULL
  ELSE exclusions
  END AS exclusions,

  CASE
  WHEN extras LIKE '%null%' or extras LIKE '%NaN%' or extras LIKE '' THEN NULL
  ELSE extras
  END AS extras,
order_time
FROM sqlchallenge_week2.customer_orders;


-- Cleaning data: runner_orders table --
-- Replacing all 'unvalid' values with nulls

CREATE OR REPLACE TABLE sqlchallenge_week2.runner_orders_temp AS
SELECT
order_id,
runner_id,
  CASE
  WHEN pickup_time LIKE '%null%' THEN NULL
  ELSE pickup_time
  END AS pickup_time,

  CASE
  WHEN distance LIKE '%null%' THEN NULL
  WHEN distance LIKE '%km' THEN RTRIM(distance, 'km')

  ELSE distance
  END AS distance,

  CASE 
  WHEN duration LIKE '%null%' THEN NULL
  WHEN duration LIKE '%minutes' THEN RTRIM(duration,'minutes')
  WHEN duration LIKE '%mins' THEN RTRIM(duration,'mins')
  WHEN duration LIKE '%minute' THEN RTRIM(duration, 'minute')
  ELSE duration
  END AS duration,

  CASE
  WHEN cancellation LIKE '%null%' or cancellation LIKE '' THEN NULL
  ELSE cancellation
  END AS cancellation

FROM sqlchallenge_week2.runner_orders;

-- Updating data types

CREATE OR REPLACE TABLE sqlchallenge_week2.runner_orders_c AS
SELECT
order_id,
runner_id,
CAST(pickup_time AS datetime) AS pickup_time,
CAST(distance AS FLOAT64) AS distance,
CAST(duration AS INT64) AS duration,
cancellation
FROM sqlchallenge_week2.runner_orders_temp;

-- Drop 'temp' table

DROP TABLE sqlchallenge_week2.runner_orders_temp;

-- Check tables

SELECT * FROM sqlchallenge_week2.customer_orders_c;

SELECT * FROM sqlchallenge_week2.runner_orders_c;