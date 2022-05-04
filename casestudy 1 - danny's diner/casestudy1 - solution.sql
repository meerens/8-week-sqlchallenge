-- 8 Week SQL Challenge by Dany Ma
-- Case study 1: Danny's diner
-- https://8weeksqlchallenge.com/case-study-1/ 

-- Coded by Marian Eerens in Google BigQuery

-- Question 1
-- How many days has each customer visited the restaurant?

SELECT 
s.customer_id,
SUM(m.price) AS total_spent
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
GROUP BY s.customer_id;

-- Question 2
-- How many days has each customer visited the restaurant?

SELECT 
customer_id,
COUNT(DISTINCT order_date) AS number_of_visits 
FROM sqlchallenge_week1.sales 
GROUP BY customer_id;


-- Question 3
-- Which item was the most popular for each customer?

WITH  q3_rank_dates_cte as (
SELECT *, 
DENSE_RANK () OVER
  (PARTITION BY customer_id ORDER BY order_date ASC) AS ranknr 
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
)

SELECT 
customer_id,
product_name
FROM q3_rank_dates_cte
WHERE ranknr = 1
GROUP BY customer_id, product_name
ORDER BY 1;

-- Question 4
-- What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
m.product_name,
COUNT(*) AS times_purchased
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
GROUP BY product_name
ORDER BY times_purchased DESC
LIMIT 1;

-- Question 5
-- Which item was the most popular for each customer?

WITH  q5_items_sold_ranked_cte as (

SELECT 
s.customer_id,
s.product_id,
m.product_name,
COUNT(*) AS total_count,
DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS count_rank 
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
GROUP BY 1,2,3
)

SELECT
customer_id,
STRING_AGG(product_name, ', ') AS most_popular_items 
FROM q5_items_sold_ranked_cte
WHERE count_rank = 1
GROUP BY customer_id
ORDER BY customer_id ASC;

-- Question 6
-- Which item was purchased first by the customer after they became a member?

WITH  q6_items_after_membership_cte as
(
SELECT 
s.customer_id,
m.join_date, 
s.order_date, 
s.product_id,
DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS rank
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.members AS m
    ON s.customer_id = m.customer_id
WHERE s.order_date >= m.join_date
)

SELECT 
s.customer_id, 
me.product_name,
s.order_date
FROM q6_items_after_membership_cte AS s
JOIN sqlchallenge_week1.menu AS me
  ON s.product_id = me.product_id
WHERE rank = 1;

-- Question 7
-- Which item was purchased just before the customer became a member?

WITH  q7_items_before_membership_cte as (

SELECT 
s.customer_id,
m.join_date, 
s.order_date, 
s.product_id,
DENSE_RANK() OVER
  (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rank
-- rank puts order closest to join date first
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.members AS m
    ON s.customer_id = m.customer_id
-- only orders before membership
WHERE s.order_date < m.join_date
)

SELECT 
s.customer_id, 
me.product_name,
s.order_date
FROM q7_items_before_membership_cte AS s
JOIN sqlchallenge_week1.menu AS me
   ON s.product_id = me.product_id
-- only keeping rank 1
WHERE rank = 1
ORDER BY 1;

-- Question 8
-- What is the total items and amount spent for each member before they became a member?

SELECT 
s.customer_id AS customer,
COUNT(DISTINCT s.product_id) AS total_items,
SUM(m.price) AS amount_spent
FROM sqlchallenge_week1.sales AS s
 JOIN sqlchallenge_week1.members AS me
   ON s.customer_id = me.customer_id
 JOIN sqlchallenge_week1.menu AS m
   ON s.product_id = m.product_id
WHERE order_date < join_date 
GROUP BY 1;

-- Question 9
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier -
-- how many points would each customer have?

SELECT 
s.customer_id,
SUM
(
  CASE
  WHEN s.product_id = 1 THEN price * 20
  ELSE price * 10
  END
) AS points
FROM sqlchallenge_week1.sales AS s
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
GROUP BY 1;

-- Question 10
-- In the first week after a customer joins the program (including their join date) 
-- they earn 2x points on all items, not just sushi - 
-- how many points do customer A and B have at the end of January?

WITH  q10_eligible_cte as 
(
SELECT 
*,
join_date + 6 AS double_date
FROM sqlchallenge_week1.members
)

SELECT 
s.customer_id,
SUM 
( CASE 
  WHEN order_date >= join_date AND order_date <= double_date 
  THEN m.price * 20 
  WHEN order_date >= join_date AND order_date > double_date
  THEN IF (m.product_id = 1, m.price * 20, m.price * 10)  
  END
) AS points
FROM sqlchallenge_week1.sales AS s 
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
  JOIN q10_eligible_cte AS me 
    ON s.customer_id = me.customer_id
WHERE s.order_date <= CAST('2021-01-31' AS date) 
GROUP BY 1;

-- Bonus 1
-- Join all the things (write code for the table as shown)

SELECT
s.customer_id,
s.order_date,
m.product_name,
m.price,
CASE
  WHEN join_date IS NULL or join_date > order_date THEN 'N'
  ELSE 'Y'
  END as member, 
FROM sqlchallenge_week1.sales AS s 
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
  LEFT JOIN sqlchallenge_week1.members AS me 
    ON s.customer_id = me.customer_id
ORDER BY 1,2;

-- Bonus 2
-- Rank all the things (write code for the table as shown)

WITH  bonus1 as (

SELECT
s.customer_id,
s.order_date,
m.product_name,
m.price,
CASE
  WHEN join_date IS NULL or join_date > order_date THEN 'N'
  ELSE 'Y'
  END as member, 
FROM sqlchallenge_week1.sales AS s 
  JOIN sqlchallenge_week1.menu AS m
    ON s.product_id = m.product_id
  LEFT JOIN sqlchallenge_week1.members AS me 
    ON s.customer_id = me.customer_id
ORDER BY 1,2
)

SELECT *,
CASE
  WHEN member = 'N' THEN NULL
  ELSE RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date)
  END AS ranking
FROM bonus1
ORDER BY customer_id, order_date;