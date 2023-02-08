-- The dataset for this exercise has been derived from the Indeed Data Scientist/Analyst/Engineer dataset on kaggle.com.

-- Before beginning to answer questions, take some time to review the data dictionary and familiarize yourself with the data that is contained in each column.

-- Provide the SQL queries and answers for the following questions/tasks using the data_analyst_jobs table you have created in PostgreSQL:

-- 1. How many rows are in the data_analyst_jobs table?

select count(*)
from data_analyst_jobs;

-- 1793 rows

-- 2. Write a query to look at just the first 10 rows. What company is associated with the job posting on the 10th row?

select *
from data_analyst_jobs
limit 10;

-- ExxonMobil

-- 3. How many postings are in Tennessee? How many are there in either Tennessee or Kentucky?

select count(*) as job_postings_in_tn
from data_analyst_jobs
where location = 'TN';

select count(*) as job_postings_in_ky_or_tn
from data_analyst_jobs
where (
	location = 'TN'
	or location = 'KY'
);

-- There are 21 job postings in TN. There are 27 job postings in TN or KY.

-- 4. How many postings in Tennessee have a star rating above 4?

select count(*) as job_postings_in_tn_above_4_stars
from data_analyst_jobs
where location = 'TN'
and star_rating > 4;

-- There are 3 job postings in Tennessee that have a star rating above 4.

-- 5. How many postings in the dataset have a review count between 500 and 1000?

select count(*) as number_of_postings
from data_analyst_jobs
where review_count between 500 and 1000;

-- There 151 postings.

-- 6. Show the average star rating for companies in each state. The output should show the state as state and the average rating for the state as avg_rating. Which state shows the highest average rating?

select location as state, avg(star_rating) as avg_rating
from data_analyst_jobs
group by state
order by avg_rating desc;

-- NE (Nebraska) has the highest average rating.

-- 7. Select unique job titles from the data_analyst_jobs table. How many are there?

select count(distinct title) as unique_job_titles
from data_analyst_jobs;

-- There are 881 unique job titles.

-- 8. How many unique job titles are there for California companies?

-- 9. Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

-- 10. Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

-- 11. Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?

-- 12. How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

-- BONUS: You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.

-- Disregard any postings where the domain is NULL.
-- Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
-- Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?