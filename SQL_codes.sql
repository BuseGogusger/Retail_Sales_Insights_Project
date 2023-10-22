-- Check the data types of the columns in the table to ensure data integrity.

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'customer_shopping_data_clean';

-- Explore the dataset to find insights and trends.

-- Display the entire dataset.

SELECT * FROM [SM_Ist].[dbo].[customer_shopping_data_clean]

-- Customer Metrics: Analyze customer demographics and count.

-- 1. Customer Distribution: Calculate the age and gender distribution.

SELECT
    age_brackets,
    gender,
    COUNT(*) AS customer_count
FROM [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY age_brackets, gender
ORDER BY customer_count DESC;

-- Product Metrics: Analyze product categories and quantities.

-- 2. Best-Selling Categories: Identifying the product categories that generate the most sales.

SELECT
    category,
     ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    category
ORDER BY
    total_sales DESC;

-- 3. Product Quantity: Analyzing the quantity of products purchased in different categories.

SELECT
    category,
    SUM(quantity) AS total_quantity
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    category
ORDER BY
    total_quantity DESC;

-- Sales Metrics: Analyze sales data.

-- 4. Analyze sales per month and year, without categorization.

-- Calculate total product quantity and sales per month and year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    MONTH(invoice_date) AS invoice_month,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    MONTH(invoice_date)
ORDER BY
    invoice_year, invoice_month;

-- 5. Examine sales per month and year, categorized by product.

-- Calculate total product quantity and sales per month and year, grouped by product category.

SELECT
    YEAR(invoice_date) AS invoice_year,
    MONTH(invoice_date) AS invoice_month,
    category,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    MONTH(invoice_date),
    category
ORDER BY
    invoice_year, invoice_month, category;

-- 6. Investigate yearly sales per category.

-- Calculate total sales per category for each year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    category,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    category
ORDER BY
    invoice_year, category;

-- 7. Analyze yearly sales per product.

-- Calculate total product quantity and sales for each year.

SELECT
    YEAR(invoice_date) AS invoice_year,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date)
ORDER BY
    invoice_year;

-- 8. Combine and examine total yearly sales by category and product.

-- Calculate total product quantity and sales per category and year.

SELECT
    YEAR(invoice_date) AS invoice_year,
	category,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
	category
ORDER BY
    invoice_year, category;

-- Mall Performance Metrics: Analyze mall sales and growth.

-- 9. Analyze sales per month and year per mall.

-- Calculate total product quantity and sales per mall for each month and year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    MONTH(invoice_date) AS invoice_month,
    shopping_mall,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    MONTH(invoice_date),
    shopping_mall
ORDER BY
    invoice_year, invoice_month, shopping_mall;

-- 10. Examine yearly sales per mall.

-- Calculate total product quantity and sales per mall for each year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    shopping_mall,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    shopping_mall
ORDER BY
    invoice_year, shopping_mall;

-- 11. Break it down to the categories as well, for a more detailed analysis.

-- Calculate total product quantity and sales per mall, segmented by product category, for each month and year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    MONTH(invoice_date) AS invoice_month,
    shopping_mall,
	category,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    MONTH(invoice_date),
    shopping_mall,
	category
ORDER BY
    invoice_year, invoice_month, shopping_mall;

-- 12. Delve into yearly sales per mall, categorized by product.

-- Calculate total product quantity and sales per mall, segmented by product category, for each year.

SELECT
    YEAR(invoice_date) AS invoice_year,
    shopping_mall,
	category,
	SUM(quantity) AS total_product,
    ROUND(SUM(price),2) AS total_sales
FROM
    [SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
    YEAR(invoice_date),
    shopping_mall,
	category
ORDER BY
    invoice_year, shopping_mall;

-- Payment Method Analysis: Understand payment methods.

-- 13. Analyze the Frequency of Payment Methods Across Age and Gender.

-- 13.1. Frequency of Payment Methods by Age and Gender.

SELECT
	gender,
	age,
    payment_method,
    COUNT(*) AS frequency
FROM
	[SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
	gender,
	age,
    payment_method
ORDER BY
	age, payment_method, frequency DESC

-- 13.2. Frequency of Payment Methods by Age Brackets and Gender.

SELECT
	gender,
	age_brackets,
    payment_method,
    COUNT(*) AS frequency
FROM
	[SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
	gender,
	age_brackets,
    payment_method
ORDER BY
	age_brackets, payment_method, frequency DESC

-- Sales Growth Metrics: Calculate year-over-year and quarter-over-quarter growth.

-- 14. Calculate YoY growth in sales.

SELECT
	YEAR(invoice_date) AS invoice_year,
	ROUND(SUM(price), 2) AS total_sales,
	ROUND(LAG(SUM(price)) OVER (ORDER BY YEAR(invoice_date)), 2) AS total_sales_last_year,
	ROUND(SUM(price) - LAG(SUM(price)) OVER (ORDER BY YEAR(invoice_date)), 2) AS yoy_growth
FROM
	[SM_Ist].[dbo].[customer_shopping_data_clean]
GROUP BY
	YEAR(invoice_date)
ORDER BY
	invoice_year;

-- 15. Calculate QoQ growth in sales.

WITH QuarterSales AS (
	SELECT
    	YEAR(invoice_date) AS invoice_year,
    	DATEPART(QUARTER, invoice_date) AS invoice_quarter,
    	ROUND(SUM(price), 2) AS total_sales
	FROM
    	[SM_Ist].[dbo].[customer_shopping_data_clean]
	GROUP BY
    	YEAR(invoice_date),
    	DATEPART(QUARTER, invoice_date)
)

SELECT
	Q1.invoice_year,
	Q1.invoice_quarter,
	Q1.total_sales AS current_quarter_sales,
	LAG(Q1.total_sales) OVER (PARTITION BY Q1.invoice_year ORDER BY Q1.invoice_quarter) AS previous_quarter_sales,
	ROUND((Q1.total_sales - LAG(Q1.total_sales) OVER (PARTITION BY Q1.invoice_year ORDER BY Q1.invoice_quarter)), 2) AS qoq_growth
FROM
	QuarterSales Q1
ORDER BY
	Q1.invoice_year, Q1.invoice_quarter;
