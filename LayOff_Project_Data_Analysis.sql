
--- Exploratory Data Analysis ---

SELECT * FROM dup_layoffs2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM dup_layoffs2;

SELECT *
FROM dup_layoffs2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off;

SELECT company, industry
FROM dup_layoffs2
ORDER BY funds_raised_millions;

SELECT company, SUM(total_laid_off) AS total_layoffs
FROM dup_layoffs2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM dup_layoffs2;

SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM dup_layoffs2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) AS total_layoffs
FROM dup_layoffs2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off) AS total_layoffs
FROM dup_layoffs2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

WITH Rolling_Total_Cte AS
(	
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_layoff
FROM dup_layoffs2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_layoff, SUM(total_layoff) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total_Cte;

SELECT company, YEAR(`date`), SUM(total_laid_off) AS total_layoffs
FROM dup_layoffs2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year(Company, Years, total_layoffs) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM dup_layoffs2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER(PARTITION BY Years ORDER BY total_layoffs DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;
































