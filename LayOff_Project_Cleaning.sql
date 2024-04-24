SHOW DATABASES;
SELECT * FROM layoffs;

CREATE TABLE dup_layoffs
LIKE layoffs;

SELECT * FROM dup_layoffs;
INSERT dup_layoffs
SELECT * FROM layoffs;

WITH duplicate_cte AS
(
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM dup_layoffs
)
SELECT * FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `dup_layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM dup_layoffs2;
INSERT INTO dup_layoffs2
SELECT *, ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) AS row_num
FROM dup_layoffs;

SELECT * FROM dup_layoffs2
WHERE row_num > 1;

DELETE FROM dup_layoffs2
WHERE row_num > 1;

-- Standardizing Data --

SELECT company, TRIM(company)
FROM dup_layoffs2;

UPDATE dup_layoffs2
SET company = TRIM(company);

SELECT DISTINCT industry FROM dup_layoffs2 ORDER BY 1;
SELECT industry FROM dup_layoffs2 WHERE industry LIKE 'Crypto%';

UPDATE dup_layoffs2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country FROM dup_layoffs2 ORDER BY 1;

UPDATE dup_layoffs2
SET country = 'United States'
WHERE country LIKE 'United States%';

UPDATE dup_layoffs2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE dup_layoffs2
MODIFY COLUMN `date` DATE;

-- Dealing With Null Values and Blank Values--

SELECT * FROM dup_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
 
SELECT *
FROM dup_layoffs2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM dup_layoffs2
WHERE company = 'Airbnb';
 
SELECT t1.industry, t2.industry
FROM dup_layoffs2 t1
JOIN dup_layoffs2 t2
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE dup_layoffs2 t1
JOIN dup_layoffs2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;
 
SELECT * FROM dup_layoffs2
WHERE industry IS NULL;
 
UPDATE dup_layoffs2
SET industry = NULL
WHERE industry = '';

-- Removing Columns And Rows --

DELETE FROM dup_layoffs2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM dup_layoffs2;

ALTER TABLE dup_layoffs2
DROP COLUMN row_num;
