-- 8 Week SQL Challenge by Dany Ma
-- Case study 1: Danny's diner
-- https://8weeksqlchallenge.com/case-study-2/ 

-- Coded by Marian Eerens in Google BigQuery

-- Create sales

CREATE TABLE sqlchallenge_week1.sales (
  customer_id STRING(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sqlchallenge_week1.sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', 1),
  ('A', '2021-01-01', 2),
  ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3),
  ('A', '2021-01-11', 3),
  ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2),
  ('B', '2021-01-02', 2),
  ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1),
  ('B', '2021-01-16', 3),
  ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-01', 3),
  ('C', '2021-01-07', 3);
 
-- Create menu

CREATE TABLE sqlchallenge_week1.menu (
  product_id INTEGER,
  product_name STRING(5),
  price INTEGER
);

INSERT INTO sqlchallenge_week1.menu
  (product_id, product_name, price)
VALUES
  (1, 'sushi', 10),
  (2, 'curry', 15),
  (3, 'ramen', 12);
  
-- Create members

CREATE TABLE sqlchallenge_week1.members (
  customer_id STRING(1),
  join_date DATE
);

INSERT INTO sqlchallenge_week1.members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');
