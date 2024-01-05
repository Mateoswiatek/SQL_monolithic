-- 1
select sum(cumulative_confirmed) as total_cases_worldwide from bigquery-public-data.covid19_open_data.covid19_open_data
where date = "2020-05-25";

-- 2
with dead_by_states as (Select subregion1_name as state, sum(cumulative_deceased) as death_count from bigquery-public-data.covid19_open_data.covid19_open_data
where country_name="United States of America" and date= "2020-05-25" and subregion1_name is not null
group by subregion1_name)

select count(*) as count_of_states from dead_by_states
where death_count > 300;

-- 3
select subregion1_name as state, sum(cumulative_confirmed) as total_confirmed_cases from bigquery-public-data.covid19_open_data.covid19_open_data
where
country_code = "US" and
date = "2020-05-25" and
subregion1_name is not null
group by subregion1_name
having total_confirmed_cases > 2000
order by total_confirmed_cases desc;

-- 4
select sum(cumulative_confirmed) as total_confirmed_cases, sum(cumulative_deceased) as total_deaths, (100*sum(cumulative_deceased)/sum(cumulative_confirmed)) as case_fatality_ratio from bigquery-public-data.covid19_open_data.covid19_open_data
where
country_name = "Italy" and
date between '2020-06-01' and '2020-06-30';
-- YEAR(date) = 2020 AND MONTH(date) = 6;
-- date::varchar ~ '2020-06-__';

-- 5 
select date
from bigquery-public-data.covid19_open_data.covid19_open_data
where
country_name = "Italy" and
cumulative_deceased > 14000
order by date;

-- 6 
WITH india_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="India"
    AND date between '2020-02-22' and '2020-03-12'
  GROUP BY
    date
  ORDER BY
    date ASC
 )

, india_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases
FROM india_cases_by_date
)

select count(date) from india_previous_day_comparison
where net_new_cases = 0

-- 7 
WITH us_cases_by_date AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="United States of America"
    AND date between '2020-03-22' and '2020-04-20'
  GROUP BY
    date
  ORDER BY
    date ASC
 )

, us_previous_day_comparison AS
(SELECT
  date,
  cases,
  LAG(cases) OVER(ORDER BY date) AS previous_day,
  cases - LAG(cases) OVER(ORDER BY date) AS net_new_cases,
  100*(cases - LAG(cases) OVER(ORDER BY date))/LAG(cases) OVER(ORDER BY date) as percentage_increase
FROM us_cases_by_date
)

select date as Date, cases as Confirmed_Cases_On_Day, previous_day as Confirmed_Cases_Previous_Day, percentage_increase as Percentage_Increase_In_Cases
from us_previous_day_comparison
where percentage_increase > 5;

-- 8 
select country_name as country, sum(cumulative_recovered) as recovered_cases, sum(cumulative_confirmed) as confirmed_cases, (100*sum(cumulative_confirmed)/sum(cumulative_recovered)) as recovery_rate from bigquery-public-data.covid19_open_data.covid19_open_data
where cumulative_confirmed > 50000
and date = "2020-05-10"
group by country_name
order by recovery_rate desc
limit 5;

-- 9 
WITH
  france_cases AS (
  SELECT
    date,
    SUM(cumulative_confirmed) AS total_cases
  FROM
    `bigquery-public-data.covid19_open_data.covid19_open_data`
  WHERE
    country_name="France"
    AND date IN ('2020-01-24',
      '2020-05-25')
  GROUP BY
    date
  ORDER BY
    date)
, summary as (
SELECT
  total_cases AS first_day_cases,
  LEAD(total_cases) OVER(ORDER BY date) AS last_day_cases,
  DATE_DIFF(LEAD(date) OVER(ORDER BY date),date, day) AS days_diff
FROM
  france_cases
LIMIT 1
)

select first_day_cases, last_day_cases, days_diff, POWER((last_day_cases/first_day_cases),(1/days_diff))-1 as cdgr
from summary

-- 10 -> export data -> export with Looker Studio
select date, sum(cumulative_confirmed) as country_cases, sum(cumulative_deceased) as country_deaths
from bigquery-public-data.covid19_open_data.covid19_open_data
where
date between '2020-03-23' and '2020-04-19'
and country_name="United States of America"
group by date;


