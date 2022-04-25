-- case study 1: danny's diner
-- https://8weeksqlchallenge.com/case-study-1/ 
-- coded by Marian Eerens
-- see README.md for context on tools & process

-- step 1: create database, schema and tables in snowflake

CREATE DATABASE eight_wk_sqlchallenge;

CREATE SCHEMA week_1;

USE eight_wk_sqlchallenge.week_1;

CREATE TABLE sales 
(
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

CREATE TABLE menu 
(
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

CREATE TABLE members 
(
  customer_id VARCHAR(1),
  join_date TIMESTAMP
);

-- step 2: create file format for loading tables

CREATE OR REPLACE FILE FORMAT mycsvformat
  type = 'CSV'
  field_delimiter = ','
  skip_header = 1;

-- step 3: tables loaded via web-ui in snowflake

-- step 4: check tables

SELECT * 
FROM sales;

SELECT *
FROM menu;

SELECT *
FROM members;