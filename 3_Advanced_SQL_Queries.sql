-----Ex.1 Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years of being founded (in 3 separate columns). 
-----Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.

--Table : tutorial.crunchbase_companies_clean_date

SELECT companies.category_code,
       COUNT(DISTINCT CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '3 years'
                       THEN company_permalink END) AS acquired_3_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '5 years'
                       THEN company_permalink END) AS acquired_5_yrs,
       COUNT(CASE WHEN acquisitions.acquired_at_cleaned <= companies.founded_at_clean::timestamp + INTERVAL '10 years'
                       THEN company_permalink END) AS acquired_10_yrs,
       COUNT(1) AS total
FROM tutorial.crunchbase_companies_clean_date companies
INNER JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
ON acquisitions.company_permalink = companies.permalink
WHERE founded_at_clean IS NOT NULL
GROUP BY 1
ORDER BY 5 DESC



----- Ex. 2 Write a query that separates the `location` field into separate fields for latitude and longitude.
------You can compare your results against the actual `lat` and `lon` fields in the table.

--- Table : tutorial.sf_crime_incidents_2014_01

SELECT location,
SUBSTR(TRIM(both '()' FROM location),STRPOS(TRIM(both '()' FROM location),',')+1,STRPOS(location, ')')) as longitude,
SUBSTR(TRIM(both '()' FROM location),1,STRPOS(TRIM(both '()' FROM location),',')-1) as latitude
FROM tutorial.sf_crime_incidents_2014_01 


----- Ex. 3 Concatenate the lat and lon fields to form a field that is equivalent to the location field. (Note that the answer will have a different decimal precision.)

SELECT CONCAT('(',lat, ', ', lon,')') AS loc,location
FROM tutorial.sf_crime_incidents_2014_01