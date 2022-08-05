Greetings 👋🏼 - my name is Marian 👩🏼‍💻 and I recently embarked on a journey to level up my SQL game by starting the [8 Week SQL Challenge](https://8weeksqlchallenge.com/) by Danny Ma. 
<br><br>
This repository contains all my documentation for the challenges that I have completed so far. Keep watching 👀 this space as I add on more solutions.

### `My Process`
Solutions were coded in [Google BigQuery](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax) syntax.<br>

Each case-study folder contains the following files
- **data.sql**: compiled sql for creating tables & loading data (if no data.sql file, you'll find csv files instead)
- **datacleaning.sql**: compiled sql for cleaning data
- **solution.sql**: compiled sql for answering the challenge questions

My code was written in a [Count](https://count.co/) SQL notebook. 

From there I copied the compiled SQL to a *.sql file which you can view in the individual challenge folders. 

I also copied the markdown from the notebook to a [Craft](https://www.craft.do/) doc to which I added some additional formatting together with the screenshots and/or csv downloads so you can see tabular output from the individual notebook cells.

### `The Challenges` 
Check the links below for all the documentationion for each individual challenge.


### Danny’s Diner 🍜 
🔗 [The Challenge ](https://8weeksqlchallenge.com/case-study-1/) <br>
🔗 [SQL Notebook](https://count.co/notebook/DHRjqUjl6mZ) <br>
🔗 [Markdown / Solution Comments](https://www.craft.do/s/ygHmfzTUw8kd9z) <br>
> Lessons learnt
> - The wonderous world of CTE's or [Common Table Expressions](https://towardsdatascience.com/take-your-sql-from-good-to-great-part-1-3ae61539e92a)
> - Using WINDOW functions like [DENSE_RANK](https://dev.to/meerens/lessons-learnt-from-the-8-week-sql-challenge-window-functions-ranking-1c54)
> - Using [STRING_AGG](https://dev.to/meerens/lessons-learnt-from-the-8-week-sql-challenge-stringagg-2che) to concatenate non-null values
> - Wrapped [CASE](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions#case_expr) statements (to filter, to aggregate)


### Pizza Runner 🍕
🔗 [The Challenge ](https://8weeksqlchallenge.com/case-study-2/)  <br>
🔗 [SQL Notebook](https://count.co/notebook/SIsIb5DCIpA)<br>
🔗 [Markdown / Solution Comments](https://www.craft.do/s/1z4crhxB3nAkEk) <br>
> Lessons Learnt
> - Creating an array from a string using [STRING_AGG](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions#split)
> - [Flattening arrays](https://medium.com/firebase-developers/using-the-unnest-function-in-bigquery-to-analyze-event-parameters-in-analytics-fb828f890b42) using [UNNEST / CROSS JOIN](https://cloud.google.com/bigquery/docs/reference/standard-sql/arrays#flattening_arrays)
> - [EXTRACT](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#extract) returns an integer for the corresponding date part
> - [PARSE_DATE](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#parse_date) converts the [string representation](https://cloud.google.com/bigquery/docs/reference/standard-sql/format-elements#format_elements_date_time) of a date to a date
> - [DATE_DIFF](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions#date_diff) calculates the difference between 2 days expressed in specified datepart
> - Using [Window aggregations](https://cloud.google.com/bigquery/docs/reference/standard-sql/aggregate_functions)
> - Wrapped [CASE](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions#case_expr) statements (to filter, to aggregate)


### Foodie-Fi 🥑
🔗 [The Challenge ](https://8weeksqlchallenge.com/case-study-3/)  <br>
🔗 [SQL Notebook](https://count.co/notebook/Kk29QJxcKkL)<br>
🔗 [Markdown / Solution Comments]() <br>

<br>
<br>

![](https://github.com/meerens/8-week-sqlchallenge/blob/main/meme.jpeg)
