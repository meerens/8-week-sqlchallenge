-- 8 Week SQL Challenge by Dany Ma
-- Case study 2: Pizza runner > Pizza metrics
-- https://8weeksqlchallenge.com/case-study-2/ 

-- Coded by Marian Eerens in Google BigQuery
-- https://github.com/meerens/8-week-sqlchallenge


-- Question 1
-- How many pizza's were ordered?

SELECT 
COUNT(*) AS pizzas_ordered
-- each record in the table = an order line for a single pizza
FROM sqlchallenge_week2.customer_orders_c;


-- Question 2
-- How many unique customer orders were made?

SELECT 
COUNT(DISTINCT order_id) AS customer_orders
-- one order can contain multiple items
FROM sqlchallenge_week2.customer_orders_c;

-- Question 3
-- How many successful orders were delivered by each runner?

SELECT 
runner_id,
COUNT(DISTINCT order_id) AS succesful_orders
FROM sqlchallenge_week2.runner_orders_c
-- failed order means duration, distance, pickup_time = NULL
WHERE duration IS NOT NULL
GROUP BY runner_id
ORDER BY runner_id;

-- Question 4
-- How many of each type of pizza was delivered?

SELECT 
o.pizza_id,
n.pizza_name,
COUNT (*) AS pizzas_delivered
FROM sqlchallenge_week2.runner_orders_c AS r
  LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
    ON r.order_id = o.order_id
  JOIN sqlchallenge_week2.pizza_names AS n
    ON o.pizza_id = n.pizza_id
-- excluding orders that were NOT delivered
-- a failed order means duration, distance, pickup_time = NULL     
WHERE distance IS NOT NULL
GROUP BY o.pizza_id, n.pizza_name;


-- Question 5
-- How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
o.customer_id,
n.pizza_name,
COUNT (*) AS pizzas_ordered
FROM sqlchallenge_week2.runner_orders_c AS r
  LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
    ON r.order_id = o.order_id
  JOIN sqlchallenge_week2.pizza_names AS n
    ON o.pizza_id = n.pizza_id
GROUP BY o.customer_id, n.pizza_name
ORDER BY o.customer_id;

-- Question 6
-- What was the maximum number of pizzas delivered in a single order?

WITH  q6_countingpizzas_per_order_cte as (
    SELECT 
    o.order_id,
    COUNT(o.pizza_id) AS pizzas_per_order
    FROM sqlchallenge_week2.customer_orders_c AS o
      JOIN sqlchallenge_week2.runner_orders_c AS r
        ON o.order_id = r.order_id
    -- only delivered orders
    -- excluding orders with no pick-up time
    WHERE pickup_time IS NOT NULL
    GROUP BY order_id
    ORDER BY order_id
)

SELECT MAX(pizzas_per_order) AS max_number_in_single_order
-- taking the max value from the cte table
FROM q6_countingpizzas_per_order_cte;

-- Question 7
-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

SELECT 
o.customer_id,
-- pizzas with changes are pizzas where we have exclusions OR extras
-- pizzas with no changes means the values are null
SUM 
(
  CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END
) AS nr_unchanged_pizzas,
SUM
(
  CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END
) AS nr_changed_pizzas,
COUNT(o.pizza_id) AS pizzas_delivered
FROM sqlchallenge_week2.runner_orders_c AS r
LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
    ON r.order_id = o.order_id
-- no pick-up time means not delivered, we only need delivered pizzas
WHERE r.pickup_time IS NOT NULL
GROUP BY customer_id
ORDER BY customer_id;


-- Question 8
-- How many pizzas were delivered that had both exclusions and extras?

SELECT
SUM
(
  CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END
) AS nr_changed_pizzas,
FROM sqlchallenge_week2.runner_orders_c AS r
LEFT JOIN sqlchallenge_week2.customer_orders_c AS o
ON r.order_id = o.order_id
-- no pick-up time means not delivered, we only need delivered pizzas
WHERE r.pickup_time IS NOT NULL
ORDER BY nr_changed_pizzas;


-- Question 9
-- What was the total volume of pizzas ordered for each hour of the day?

SELECT 
EXTRACT (HOUR FROM order_time) AS hour,
COUNT(*) AS volume_ordered
FROM sqlchallenge_week2.customer_orders_c
GROUP BY hour
ORDER BY hour ASC;

-- Question 10
--- What was the volume of orders for each day of the week?

SELECT 
EXTRACT (DAYOFWEEK FROM order_time) AS weekday_int,
-- DAYOFWEEK: Returns values in the range [1,7] with Sunday as the first day of the week
CASE 
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 1 THEN 'Sunday' 
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 2 THEN 'Monday'
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 3 THEN 'Tuesday'
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 4 THEN 'Wednesday'
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 5 THEN 'Thursday'
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 6 THEN 'Friday'
  WHEN EXTRACT (DAYOFWEEK FROM order_time) = 7 THEN 'Saturday'
  ELSE 'OOPS'
END AS weekday_str,
COUNT(*) AS volume_ordered
FROM sqlchallenge_week2.customer_orders_c
GROUP BY weekday_int, weekday_str
ORDER BY weekday_int ASC; 