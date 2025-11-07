# NetfliX Movies and Tv Shows Anlysis Using SQL

 ![](https://github.com/Nenye-anne/Netflix_SQL_PROJECT/blob/main/logo.png)
 
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type, 
    COUNT(*) AS total_content
FROM Netflix
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
Select*
From Netflix
Where type ='Movie' 
and release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
   TOP 5 TRIM(value) AS new_country,
    COUNT(Show_id) AS total_content
FROM Netflix
CROSS APPLY STRING_SPLIT(country, ',')
GROUP BY TRIM(value)
ORDER BY total_content DESC;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT *
FROM NETFLIX
WHERE TYPE = 'MOVIE'
AND DURATION = (SELECT MAX(DURATION) FROM NETFLIX);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM Netflix
WHERE date_added >= DATEADD(YEAR, -5, GETDATE());
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
Select *
From Netflix
Where director Like '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT *
FROM Netflix
WHERE type = 'TV Show' 
  AND CAST(LEFT(duration, CHARINDEX(' ', duration) - 1) AS INT) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
    TRIM(value) AS Genre,
    COUNT(show_id) AS Total_Shows
FROM netflix
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY TRIM(value);
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT RIGHT(date_added, 4) AS year,
       COUNT(*) AS total_content,
       CAST(COUNT(*) AS NUMERIC(10,2)) / 
       (SELECT COUNT(*)
	   FROM Netflix 
	   WHERE Country = 'United States') * 100 AS Avg_Content_Per_Year
FROM Netflix
WHERE Country = 'United States'
GROUP BY RIGHT(date_added, 4);
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by USA highlight regional content distribution.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.







