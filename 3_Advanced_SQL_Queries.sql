-----Ex.1 Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years of being founded (in 3 separate columns). 
-----Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.

--Table : tutorial.crunchbase_companies_clean_date

SELECT 
 SUM(CASE WHEN founded_time_ago between 0 and 3 then companies else 0 end) as three_yrs,
 
  SUM(CASE WHEN founded_time_ago between 0 and 5 then companies else 0 end) as five_yrs,
  
   SUM(CASE WHEN founded_time_ago between 0 and 10 then companies else 0 end) as ten_yrs,
 sum(companies) as total
 
FROM
(
SELECT
NOW() - companies.founded_at_clean::timestamp AS founded_time_ago ,
COUNT(DISTINCT companies.permalink) AS companies
FROM tutorial.crunchbase_companies_clean_date companies  
WHERE founded_at_clean >='2000-01-01'
GROUP BY 1
)a