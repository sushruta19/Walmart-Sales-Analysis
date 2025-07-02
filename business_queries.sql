SHOW DATABASES;
USE walmart_db;
SHOW TABLES;
DESCRIBE walmart;

-- Converting date to DATE type
ALTER TABLE walmart ADD COLUMN parsed_date DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE walmart
SET parsed_date = STR_TO_DATE(`date`, '%d/%m/%y');

ALTER TABLE walmart DROP COLUMN `date`;
SET SQL_SAFE_UPDATES = 1;

-- display first 5 rows
SELECT * FROM walmart
LIMIT 5;

-- number of rows
SELECT COUNT(*) FROM walmart;

-- count of each payment type
SELECT payment_method, COUNT(*)
FROM walmart
GROUP BY payment_method;

-- number of distinct branches
SELECT COUNT(DISTINCT Branch)
FROM walmart;

-- maximum quantity order
SELECT MAX(quantity) FROM walmart;

-- min can never be 0 since it wouldn't be included in database in first place
SELECT MIN(quantity) FROM walmart;

-- Business Problems
-- Q1. Find different payment methods and number of transactions, number of qty sold
SELECT payment_method, COUNT(*) AS transaction_count, SUM(quantity) AS quantity_sold
FROM walmart
GROUP BY payment_method
ORDER BY transaction_count DESC;

-- Q2. Identify the highest-rated category in each branch, displaying the branch, category, avg rating
SELECT branch, category, avg_rating AS avg_rating_highest
FROM
(	SELECT
		branch,
		category,
		AVG(rating) AS avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(RATING) DESC) AS rank_rating
	FROM walmart
	GROUP BY branch, category
) AS ranked
WHERE rank_rating=1;

-- Q3. Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, transaction_count
FROM
	(SELECT 
		branch,
        DAYNAME(parsed_date) AS day_name, 
		COUNT(*) AS transaction_count,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank_rating
	FROM walmart
	GROUP BY branch, day_name
    ) AS ranked
WHERE rank_rating = 1;


-- Q4. Identify the busiest dates for each branch based on the number of transactions
SELECT branch, parsed_date AS busiest_dates, transaction_cnt
FROM(
	SELECT 
		branch,
		parsed_date,
		COUNT(*) AS transaction_cnt,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_rating
	FROM walmart
	GROUP BY branch, parsed_date
) AS ranked
WHERE rank_rating = 1;

-- Q5. How many items were sold through each payment method?
SELECT
	payment_method,
    SUM(quantity) AS items_sold
FROM walmart
GROUP BY payment_method;

-- Q6. What are the average, minimum, and maximum ratings for each category in each city?
SELECT
	category,
    city,
    MIN(rating) AS min_rating,
    AVG(rating) AS avg_rating,
    MAX(rating) AS max_rating
FROM walmart
GROUP By category, city
ORDER BY category, avg_rating DESC;

--  Q7. What is the total profit for each category, ranked from highest to lowest?
SELECT category, SUM(profit_margin*total) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Q8. What is the most frequently used payment method in each branch?
SELECT branch, payment_method AS preferred_payment_method
FROM
	(SELECT 
		branch,
		payment_method,
		COUNT(*) AS payment_cnt,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_rating
	FROM walmart
	GROUP BY branch, payment_method
	) AS ranked
WHERE rank_rating = 1;	
-- Another way of doing the above using CTE
WITH cte
AS
(SELECT 
	branch,
	payment_method,
	COUNT(*) AS payment_cnt,
	RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_rating
FROM walmart
GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method FROM cte
WHERE rank_rating = 1;


-- Q9. How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
SELECT branch, shift, COUNT(*) AS transaction_count
FROM(	
    SELECT
		branch,
		CASE
			WHEN HOUR(STR_TO_DATE(`time`, '%H:%i:%s')) BETWEEN 6 AND 11 THEN 'Morning'
			WHEN HOUR(STR_TO_DATE(`time`, '%H:%i:%s')) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM walmart
) AS shifted
GROUP BY branch, shift
ORDER BY branch, FIELD(shift, 'Morning', 'Afternoon', 'Evening'); -- custom ordering

-- Q10. Which branches experienced the largest decrease in revenue compared to the previous year? Current is 2023 and previous is 2022

-- revenue for 2022 each branch
WITH revenue_2022
AS(
	SELECT
		branch,
		SUM(total) AS revenue
	FROM walmart
	WHERE YEAR(parsed_date) = 2022
	GROUP BY branch
),
revenue_2023 -- revenue for 2023, each branch
AS(
	SELECT
		branch,
		SUM(total) AS revenue
	FROM walmart
	WHERE YEAR(parsed_date) = 2023
	GROUP BY branch
)
SELECT
	r2022.branch,
    r2022.revenue AS last_yr_revenue,
    r2023.revenue AS curr_yr_revenue,
    ROUND((r2022.revenue-r2023.revenue)/r2022.revenue * 100, 2) AS revenue_decrease_percentage
FROM revenue_2022 r2022
JOIN
revenue_2023 r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_percentage DESC;
-- LIMIT 5; you can use this to get the top 5 worst performing branches
