
-- OPERATION ANALYTICS OF A COMPANY --

-- A. Number of jobs reviewed: Amount of jobs reviewed over time.
-- Task: Calculate the number of jobs reviewed per hour per day for November 2020? 

-- To get perhour perday we are using the number of distinct job_id and dividing it with 30 days * 24 hours 
-- it is not necessary to use where clause here because the data given is only of November month but if it is otherwise it helps  

SELECT 
	COUNT(DISTINCT job_id)/(30*24)as JOBS_PER_HOUR_PER_DAY 
FROM job_data
WHERE month(ds)= "11";

-- B. Throughput: It is the no. of events happening per second.
-- task: Let’s say the above metric is called throughput. 
-- Calculate 7 day rolling average of throughput? 
-- For throughput, do you prefer daily metric or 7-day rolling and why?

-- Here 7-day rolling average is preferred, we are getting the number of jobs reviewed form the inner query first then we are getting the average of jobs reviewed
-- Since we need 7-day rolling we are forming window for ROWS BETWEEN 6 RECEEDING AND CURRENT ROW
 
SELECT ds, jobs_reviewed, 
 AVG(jobs_reviewed)OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND 
CURRENT ROW)AS 7_day_rolling_avg FROM 
(
SELECT ds, COUNT(DISTINCT job_id) AS jobs_reviewed
FROM job_data WHERE monthname(ds)= "November"
GROUP BY ds 
ORDER BY ds)a; 

-- C. Percentage share of each language: Share of each language for different contents.
-- Your task: Calculate the percentage share of each language in the last 30 days?

SELECT 
	job_id, 
    language, 
    count(language) as each_language_count, 
    (count(language)/(select count(*)from job_data)) * 100 as per_share_of_each_language
FROM job_data
group by language
order by language;

-- D.Duplicate rows: Rows that have the same value present in them.
-- Task: Let’s say you see some duplicate rows in the data. How will you display duplicates from the table?

SELECT *  
FROM  
( SELECT *, 
ROW_NUMBER()OVER(PARTITION  BY job_id) AS rownum 
FROM job_data 
)a 
WHERE rownum > 1;


