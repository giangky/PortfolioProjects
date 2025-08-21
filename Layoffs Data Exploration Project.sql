/*

Layoffs Data Exploration using CTEs, Aggregate Functions

*/

SELECT * FROM layoffs_staging2;

-- Max Employees Laid Off and Max Percentage of Company Laid Off at One Moment
SELECT max(total_laid_off), max(percentage_laid_off) FROM layoffs_staging2;

SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; 

-- Layoffs During 2020
SELECT * FROM layoffs_staging2
WHERE date > '2020-01-01' AND date < '2021-01-01'
ORDER BY funds_raised_millions DESC;

SELECT * FROM layoffs_staging2
WHERE year(date) = 2020
ORDER BY funds_raised_millions DESC;

-- Companies with Most Layoffs 
SELECT company, sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY sum(total_laid_off) DESC;

-- Industries with Most Layoffs
SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Countries with Most Layoffs
SELECT country, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Year with Most Layoffs (2020 and 2023 data does not encompass full year)
SELECT year(date), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY 1
ORDER BY 2 DESC;

-- Layoffs per Month
SELECT substring(date, 1, 7) AS `Month`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(date, 1, 7) IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT * FROM layoffs_staging2;

-- Rolling Total for Each Month
WITH Rolling_Total as (
	SELECT substring(date, 1, 7) AS `month` , SUM(total_laid_off) AS total_off
	FROM layoffs_staging2
	WHERE substring(date, 1, 7) IS NOT NULL
	GROUP BY 1
	ORDER BY 1
) SELECT `month`, total_off, sum(total_off) OVER(ORDER BY `month`) AS rolling_total
FROM Rolling_Total;

-- Most Layoffs in a Company in a Year
SELECT company, year(date), sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, 2
ORDER BY 3 DESC;

-- Top 5 Companies Each Year with Most Layoffs
WITH Company_Year (company, year, total_laid_off) AS (
SELECT company, year(date), sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY company, 2
), Company_Year_Rank AS (
 SELECT *, DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE total_laid_off IS NOT NULL AND year IS NOT NULL
) 
SELECT * FROM Company_Year_Rank
WHERE Ranking < 6
;

-- Top 5 Industries Each Year with Most Layoffs
WITH Industry_Year (industry, year, total_laid_off) AS (
SELECT industry, year(date), sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry, 2
), Industry_Year_Rank AS (
 SELECT *, DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC) AS Ranking
FROM Industry_Year
WHERE total_laid_off IS NOT NULL AND year IS NOT NULL
) 
SELECT * FROM Industry_Year_Rank
WHERE Ranking < 6
;

