-- 8 Week SQL Challenge by Dany Ma
-- Case study 2: Pizza runner > Runner & customer experience
-- https://8weeksqlchallenge.com/case-study-2/ 

-- Coded by Marian Eerens in Google BigQuery
-- https://github.com/meerens/8-week-sqlchallenge


-- Question 1
-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

-- final solution
SELECT 
EXTRACT(WEEK(FRIDAY) FROM registration_date) AS weekperiod,
COUNT(*) AS nr_runners
FROM sqlchallenge_week2.runners
GROUP BY 1
ORDER BY 1;

-- Question 2
-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

WITH  q2_difference_in_minutes_cte as (
    SELECT 
    o.order_id,
    r.runner_id,
    -- DATE_DIFF(date_expression_a, date_expression_b, date_part)
    -- extracting datetime from the timestamp to be able to make the calculation
    DATE_DIFF(r.pickup_time, EXTRACT (datetime FROM o.order_time),minute) AS minutes
    FROM sqlchallenge_week2.runner_orders_c AS r
      LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
        ON r.order_id = o.order_id
    GROUP BY o.order_id, r.runner_id, minutes
    ORDER BY o.order_id ASC
)

SELECT 
runner_id,
AVG(minutes) AS avg_time_in_minutes
FROM q2_difference_in_minutes_cte
GROUP BY runner_id
ORDER BY runner_id;

-- Question 3
-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH  q3_pizzas_minutes_per_order_cte as (
    SELECT 
    o.order_id,
    DATE_DIFF(r.pickup_time, EXTRACT (datetime FROM o.order_time),minute) AS minutes,
    -- counting all rows, every row represents a single pizza on an order
    -- looking at all orders, not just the ones that got delivered
    COUNT(*) AS number_pizzas_per_order
    FROM sqlchallenge_week2.runner_orders_c AS r
      LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
        ON r.order_id = o.order_id
    -- exlcuding the orders that didn't got cancelled
    -- meaning there is no pickup_time    
    WHERE pickup_time IS NOT NULL
    GROUP BY o.order_id, minutes
    ORDER BY o.order_id ASC
)

SELECT 
number_pizzas_per_order,
AVG(minutes) AS avg_minutes
FROM q3_pizzas_minutes_per_order_cte
GROUP BY number_pizzas_per_order
ORDER BY number_pizzas_per_order;

-- Question 4
-- What was the average distance travelled for each customer?

SELECT 
o.customer_id,
AVG(distance) AS avg_distance
FROM sqlchallenge_week2.runner_orders_c AS r
  LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
    ON r.order_id = o.order_id
-- WHERE distance IS NOT NULL
GROUP BY customer_id
ORDER BY customer_id ASC;

-- Question 5
-- What was the difference between the longest and shortest delivery times for all orders?

SELECT 
MIN(duration) AS min_duration,
MAX(duration) AS max_ducation,
MAX(duration) - MIN(duration) AS difference
FROM sqlchallenge_week2.runner_orders_c
WHERE duration IS NOT NULL;

-- Question 6
-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH  
q6_speed_order_cte as (
    SELECT *, 
    distance / (duration / 60) AS km_per_hour
    FROM sqlchallenge_week2.runner_orders_c
    WHERE pickup_time IS NOT NULL
),

q6_avg_speed_cte as (
    SELECT 
    runner_id,
    order_id,
    AVG(km_per_hour) AS avg_speed,
    FROM q6_speed_order_cte
    GROUP BY runner_id, order_id
)

SELECT *,
-- the average per runner
AVG(avg_speed) 
  OVER (PARTITION BY runner_id ORDER BY order_id
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS avg_per_runner,
-- the overall average (the entire table)
AVG(avg_speed) 
  OVER () AS avg_all_runners,
ABS(avg_speed - AVG(avg_speed) 
  OVER (PARTITION BY runner_id ORDER BY order_id
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS difference_runner,
ABS(avg_speed - AVG(avg_speed) 
  OVER ()) AS difference_all_runners
FROM q6_avg_speed_cte
ORDER BY runner_id ASC, order_id ASC;

-- Question 7
-- What is the successful delivery percentage for each runner?

SELECT 
runner_id,
CAST 
(ROUND
  (100 * SUM(
     CASE 
     WHEN DURATION IS NOT NULL THEN 1
     ELSE 0 END) 
     / COUNT(*)
  ) 
AS string) || '%' AS successful_deliveries
FROM sqlchallenge_week2.runner_orders_c
GROUP BY runner_id
ORDER BY runner_id ASC;