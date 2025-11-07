
--- Create database
Create Database Netflix_DB;
----Import Table Name Netflix
---- call out table
Select*
From Netflix;
--- Type of shows on netflix
Select Distinct type
From Netflix;
---- 10 Business Problems
---1. Count the number of movies vs tv shows
SELECT 
    type, 
    COUNT(*) AS total_content
FROM Netflix
GROUP BY type;
---2 Find the most common rating for tv shows and movies
SELECT
    type,
    rating
FROM (
    SELECT
        type,
        rating,
        COUNT(*) as count_records,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
    FROM Netflix
    GROUP BY type, rating
) as t1
WHERE ranking = 1;
----- 3 list all the movies released in the year 2020
Select*
From Netflix
Where type ='Movie' 
and release_year = 2020;
-------4 find the top 5 countries with content on netflix
SELECT 
   TOP 5 TRIM(value) AS new_country,
    COUNT(Show_id) AS total_content
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;
--- 5 IDENTIFY THE LONGEST MOVIE 
SELECT *
FROM NETFLIX
WHERE TYPE = 'MOVIE'
AND DURATION = (SELECT MAX(DURATION) FROM NETFLIX);
-----6 find the content added in the last 5 years
SELECT *
FROM Netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());
------ 7 Find all the movies by the director 'Rajiv Chilaka'
Select *
From Netflix
Where director Like '%Rajiv Chilaka%';
------ 8 List all TV Shows with more than 5 Seasons
SELECT *
FROM Netflix
WHERE type = 'TV Show' 
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;
-------9 Count the number of content in each genre 
SELECT 
    TRIM(value) AS Genre,
    COUNT(show_id) AS Total_Shows
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value);
------10 Find each year and the average number of content released in united state on netflix. return the top 5 highest avg content released
SELECT RIGHT(date_added, 4) AS year,
       COUNT(*) AS total_content,
       CAST(COUNT(*) AS NUMERIC(10,2)) / 
       (SELECT COUNT(*)
	   FROM Netflix 
	   WHERE Country = 'United States') * 100 AS Avg_Content_Per_Year
FROM Netflix
WHERE Country = 'United States'
GROUP BY RIGHT(date_added, 4);



