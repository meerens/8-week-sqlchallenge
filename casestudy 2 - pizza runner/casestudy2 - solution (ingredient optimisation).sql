-- 8 Week SQL Challenge by Dany Ma
-- Case study 2: Pizza runner > Ingredient optimisation
-- https://8weeksqlchallenge.com/case-study-2/ 

-- Coded by Marian Eerens in Google BigQuery
-- https://github.com/meerens/8-week-sqlchallenge

-- Question 1
-- What are the standard ingredients for each pizza?

WITH  
q1_pizzarecipe_to_array_cte as (
    -- converting topping_id string to array
    SELECT
    pizza_id,
    SPLIT(toppings,', ') AS topping_id
    FROM
    sqlchallenge_week2.pizza_recipes
),

q1_unnest_array_int_cte as (
    -- array to columns
    SELECT 
    pizza_id, 
    CAST(toppings AS INT64) AS topping_id
    FROM q1_pizzarecipe_to_array_cte
    CROSS JOIN 
      UNNEST(topping_id) as toppings
)

SELECT 
pizza_name AS pizza,
STRING_AGG(topping_name, ', ') AS toppings
FROM q1_unnest_array_int_cte AS i
  JOIN sqlchallenge_week2.pizza_toppings AS t
    ON i.topping_id = t.topping_id
  JOIN sqlchallenge_week2.pizza_names AS n
    ON i.pizza_id = n.pizza_id
GROUP BY pizza_name;

-- Question 2
-- What was the most commonly added extra?

WITH  
q2_pizzas_with_extras_cte as (
    SELECT 
    order_id,
    pizza_id,
    SPLIT(extras, ', ') AS extras
    FROM sqlchallenge_week2.customer_orders_c
    -- the question is about extras so we're excluding the rows that don't have any
    WHERE extras IS NOT NULL
),
 
q2_pizzas_extras_unnest_cte as (
    SELECT 
    order_id,
    pizza_id,
    CAST(extras AS INT64) AS extras
    FROM q2_pizzas_with_extras_cte
    CROSS JOIN 
      UNNEST(extras) as extras
)

SELECT 
extras,
topping_name,
COUNT(*) AS number_of_times_used_as_extra
FROM q2_pizzas_extras_unnest_cte AS e
  JOIN sqlchallenge_week2.pizza_toppings AS t
    ON e.extras = t.topping_id
GROUP BY extras, topping_name
ORDER BY number_of_times_used_as_extra DESC;
  

-- Question 3
-- What was the most common exclusion?

-- Question 4
-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers

WITH  
q4_customer_orders_new_cte as (
    SELECT -*, 
    ROW_NUMBER() OVER() AS index
    FROM sqlchallenge_week2.customer_orders_c
),

q4_extras_cte as (
    SELECT 
    order_id,
    pizza_id,
    index,
    SPLIT(extras, ', ') AS extras
    FROM q4_customer_orders_new_cte
    WHERE extras IS NOT NULL
),

q4_exclusions_cte as (
    SELECT 
    order_id,
    pizza_id,
    index,
    SPLIT(exclusions, ', ') AS exclusions
    FROM q4_customer_orders_new_cte
    WHERE exclusions IS NOT NULL
),

q4_unnest_extras_cte as (
    SELECT 
    order_id,
    pizza_id,
    index,
    CAST(extras AS INT64) AS extras
    FROM q4_extras_cte
    CROSS JOIN 
      UNNEST(extras) as extras
),

q4_unnest_exclusions_cte as (
    SELECT 
    order_id,
    pizza_id,
    index,
    CAST(exclusions AS INT64) AS exclusions
    FROM q4_exclusions_cte
    CROSS JOIN 
      UNNEST(exclusions) as exclusions
),

q4_extras_names_cte as (
    SELECT 
    order_id,
    pizza_id,
    index,
    '- Extra '|| STRING_AGG(topping_name, ', ') AS extra_names
    FROM q4_unnest_extras_cte
      JOIN sqlchallenge_week2.pizza_toppings
        ON extras = topping_id
    GROUP BY order_id, pizza_id, index
),
q4_exclusions_names_cte as (
    SELECT 
    order_id, 
    pizza_id,
    index,
    '- Exclude '|| STRING_AGG(topping_name, ', ') AS exclusion_names
    FROM q4_unnest_exclusions_cte
      JOIN sqlchallenge_week2.pizza_toppings
        ON exclusions = topping_id
    GROUP BY order_id, pizza_id, index
)

SELECT 
o.order_id,
o.customer_id,
--o.pizza_id,
--o.exclusions,
--o.extras,
--o.order_time,
CASE 
  WHEN extras IS NULL AND exclusions IS NULL 
    THEN p.pizza_name
  WHEN extras IS NOT NULL AND  exclusions IS NOT NULL 
    THEN p.pizza_name|| ' '||l.exclusion_names||' '|| x.extra_names
  WHEN extras IS NOT NULL AND exclusions IS NULL 
    THEN p.pizza_name||' '|| x.extra_names
  WHEN extras IS NULL AND exclusions IS NOT NULL 
    THEN p.pizza_name||' '|| l.exclusion_names
  ELSE 'OOPS'
END AS order_item
FROM q4_customer_orders_new_cte AS o
  LEFT JOIN sqlchallenge_week2.pizza_names AS p
    ON o.pizza_id = p.pizza_id
  LEFT JOIN q4_exclusions_names_cte AS l
    ON o.index = l.index
  LEFT JOIN q4_extras_names_cte AS x 
    ON o.index = x.index
ORDER BY o.order_id ASC

-- Question 5
-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients.
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

-- Question 6
-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?