-- 1
SELECT SUM(cumulative_confirmed) AS total_cases_worldwide FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE DATE = "2020-05-25";

-- 2
with dead_by_states AS (SELECT subregion1_name AS state, SUM(cumulative_deceased) AS death_count FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE country_name="United States of America" AND DATE= "2020-05-25" AND subregion1_name IS NOT NULL
GROUP BY subregion1_name)

SELECT COUNT(*) AS count_of_states FROM dead_by_states
WHERE death_count > 300;

-- 3
SELECT subregion1_name AS state, SUM(cumulative_confirmed) AS total_confirmed_cases FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE
country_code = "US" AND
DATE = "2020-05-25" AND
subregion1_name IS NOT NULL
GROUP BY subregion1_name
HAVING total_confirmed_cases > 2000
ORDER BY total_confirmed_cases DESC;

-- 4
SELECT SUM(cumulative_confirmed) AS total_confirmed_cases, SUM(cumulative_deceased) AS total_deaths, (100*SUM(cumulative_deceased)/SUM(cumulative_confirmed)) AS case_fatality_ratio FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE
country_name = "Italy" AND
DATE between '2020-06-01' AND '2020-06-30';
-- YEAR(DATE) = 2020 AND MONTH(DATE) = 6;
-- DATE::VARCHAR ~ '2020-06-__';

-- 5 
SELECT DATE
FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE
country_name = "Italy" AND
cumulative_deceased > 14000
ORDER BY DATE;

-- 6 
WITH india_cases_by_date AS (
  SELECT
    DATE,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="India"
    AND DATE between '2020-02-22' AND '2020-03-12'
  GROUP BY
    DATE
  ORDER BY
    DATE ASC
 )

, india_previous_day_comparison AS
(SELECT
  DATE,
  cases,
  LAG(cases) OVER(ORDER BY DATE) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY DATE) AS net_new_cases
FROM india_cases_by_date
)

SELECT COUNT(DATE) FROM india_previous_day_comparison
WHERE net_new_cases = 0

-- 7 
WITH us_cases_by_date AS (
  SELECT
    DATE,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="United States of America"
    AND DATE between '2020-03-22' AND '2020-04-20'
  GROUP BY
    DATE
  ORDER BY
    DATE ASC
 )

, us_previous_day_comparison AS
(SELECT
  DATE,
  cases,
  LAG(cases) OVER(ORDER BY DATE) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY DATE) AS net_new_cases,
  100*(cases - LAG(cases) OVER(ORDER BY DATE))/LAG(cases) OVER(ORDER BY DATE) AS percentage_increase
FROM us_cases_by_date
)

SELECT DATE AS DATE, cases AS Confirmed_Cases_On_Day, previous_day AS Confirmed_Cases_Previous_Day, percentage_increase AS Percentage_Increase_In_Cases
FROM us_previous_day_comparison
WHERE percentage_increase > 5;

-- 8 
SELECT country_name AS country, SUM(cumulative_recovered) AS recovered_cases, SUM(cumulative_confirmed) AS confirmed_cases, (100*SUM(cumulative_confirmed)/SUM(cumulative_recovered)) AS recovery_rate FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE cumulative_confirmed > 50000
AND DATE = "2020-05-10"
GROUP BY country_name
ORDER BY recovery_rate DESC
LIMIT 5;

-- 9 
WITH
  france_cases AS (
  SELECT
    DATE,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND DATE IN ('2020-01-24',
      '2020-05-25')
  GROUP BY
    DATE
  ORDER BY
    DATE)
, summary AS (
SELECT
  total_cases AS first_day_cases,
  LEAD(total_cases) OVER(ORDER BY DATE) AS last_day_cases,
  DATE_DIFF(LEAD(DATE) OVER(ORDER BY DATE),DATE, day) AS days_diff
FROM
  france_cases
LIMIT 1
)

SELECT first_day_cases, last_day_cases, days_diff, POWER((last_day_cases/first_day_cases),(1/days_diff))-1 AS cdgr
FROM summary

-- 10 -> export data -> export with Looker Studio
SELECT DATE, SUM(cumulative_confirmed) AS country_cases, SUM(cumulative_deceased) AS country_deaths
FROM bigquery-public-data.covid19_open_data.covid19_open_data
WHERE
DATE between '2020-03-23' AND '2020-04-19'
AND country_name="United States of America"
GROUP BY DATE;


