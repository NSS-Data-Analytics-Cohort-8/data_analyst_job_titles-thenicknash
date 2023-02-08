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
where location is not null
group by state
order by avg_rating desc;

-- NE (Nebraska) has the highest average rating.

-- 7. Select unique job titles from the data_analyst_jobs table. How many are there?

select count(distinct title) as unique_job_titles
from data_analyst_jobs;

-- There are 881 unique job titles.

-- 8. How many unique job titles are there for California companies?

select count(distinct title) as unique_job_titles_in_ca
from data_analyst_jobs
where location = 'CA';

-- There are 230 unique job titles in California.

-- 9. Find the name of each company and its average star rating for all companies that have more than 5000 reviews across all locations. How many companies are there with more that 5000 reviews across all locations?

select company, avg(star_rating) as avg_rating
from data_analyst_jobs
where review_count > 5000
and company is not null
group by company;

-- There are 40 (excluding 1 null entry) companies that have more than 5000 reviews.

-- 10. Add the code to order the query in #9 from highest to lowest average star rating. Which company with more than 5000 reviews across all locations in the dataset has the highest star rating? What is that rating?

select company, avg(star_rating) as avg_rating
from data_analyst_jobs
where review_count > 5000
and company is not null
group by company
order by avg_rating desc;

-- General Motors, Unilever, Microsoft, Nike, American Express, and Kaiser Permanente all have ~ 4.19 average star ratings.

-- 11. Find all the job titles that contain the word ‘Analyst’. How many different job titles are there?

select distinct title
from data_analyst_jobs
where lower(title) like '%analyst%';

-- There are 323 different job titles containing the word 'Analyst'.

-- 12. How many different job titles do not contain either the word ‘Analyst’ or the word ‘Analytics’? What word do these positions have in common?

select distinct title
from data_analyst_jobs
where (
	lower(title) not like '%analyst%'
	or lower(title) not like '%analytics%'
);

-- There are 801 different job titles that do not contain the word ‘Analyst’ or the word ‘Analytics’.

-- BONUS: You want to understand which jobs requiring SQL are hard to fill. Find the number of jobs by industry (domain) that require SQL and have been posted longer than 3 weeks.

select domain as industry, count(*) as number_of_jobs
from data_analyst_jobs
where lower(skill) like '%sql%'
and days_since_posting > 21
and domain is not null
group by industry
order by number_of_jobs desc;

-- Disregard any postings where the domain is NULL.
-- Order your results so that the domain with the greatest number of hard to fill jobs is at the top.
-- Which three industries are in the top 4 on this list? How many jobs have been listed for more than 3 weeks for each of the top 4?

-- The four industries in the top 4 are Internet and Software (62 jobs), Banks and Financial Services (61 jobs), Consulting and Business Services (57 jobs), and Health Care (6522 jobs).


-- Amanda Questions

-- 1. For each company, give the company name and the difference between its star rating and the national average star rating.

-- NOTE: I am excluding records where the company name is null and where there is not at least 1 star rating
select
	company,
	avg(star_rating) as company_avg_rating,
	(avg(star_rating) - (
		select avg(star_rating) 
		from data_analyst_jobs
	)) as diff_between_company_and_natl_avg_rating,
	(
		select avg(star_rating) 
		from data_analyst_jobs
	) as national_avg_rating
from data_analyst_jobs
where star_rating is not null
and company is not null
group by company;

-- 2. Using a correlated subquery: For each company, give the company name, its domain, its star rating, and its domain average star rating

select
	distinct daj.company,
	daj.domain,
	daj.star_rating as company_rating,
	(
		select avg(daj_2.star_rating)
		from data_analyst_jobs as daj_2
		where daj_2.domain = daj.domain
	) as domain_avg_rating
from data_analyst_jobs as daj
where daj.domain is not null
and daj.star_rating is not null;

-- 3. Repeat question 2 using a CTE instead of a correlated subquery

with cte_domain_avg_rating as (
	select
		domain,
		avg(star_rating) as domain_avg_rating
	from data_analyst_jobs
	group by domain
)
select
	distinct daj.company,
	daj.domain,
	daj.star_rating as company_rating,
	cte_domain_avg_rating.domain_avg_rating
from data_analyst_jobs as daj
inner join cte_domain_avg_rating
on daj.domain = cte_domain_avg_rating.domain
where daj.domain is not null
and daj.star_rating is not null;