-- SQL Portfolio Project: Report Generation System
-- This script contains all the queries needed for the project.
-- It is written in a standard SQL dialect but may require minor
-- adjustments for specific databases (e.g., date functions).

-- ====================================================================
-- Step 1: Data Exploration
-- First, let's explore the data to understand its structure and content.
-- ====================================================================

-- View the first 10 rows of the dataset
SELECT * FROM superstore LIMIT 10;

-- Get a summary of all columns, their data types
-- Note: The command to describe a table varies by SQL dialect.
-- For PostgreSQL: \d superstore
-- For MySQL: DESCRIBE superstore;
-- For SQL Server: EXEC sp_columns 'superstore';

-- Find the date range of the orders
SELECT
    MIN("Order Date") AS first_order_date,
    MAX("Order Date") AS last_order_date
FROM superstore;


-- ====================================================================
-- Step 2: Data Aggregation (Key Financial Metrics)
-- Here, we perform basic aggregations to get high-level financial metrics.
-- ====================================================================

-- Calculate total revenue, total profit, and overall profit margin
SELECT
    SUM(Sales) AS total_revenue,
    SUM(Profit) AS total_profit,
    (SUM(Profit) / SUM(Sales)) * 100 AS overall_profit_margin_percentage
FROM superstore;


-- ====================================================================
-- Step 3: Monthly Summary Reports
-- This is the core of the project. We create monthly reports to
-- highlight key financial metrics and trends.
-- ====================================================================

-- Create a monthly report of revenue, profit, and number of orders.
-- Note on Date Functions:
-- - SQLite: strftime('%Y-%m', "Order Date")
-- - PostgreSQL: TO_CHAR("Order Date", 'YYYY-MM')
-- - MySQL: DATE_FORMAT("Order Date", '%Y-%m')
-- - SQL Server: FORMAT("Order Date", 'yyyy-MM')
-- We will use the standard SQL EXTRACT function where possible, which is more portable.

SELECT
    EXTRACT(YEAR FROM "Order Date") AS order_year,
    EXTRACT(MONTH FROM "Order Date") AS order_month,
    SUM(Sales) AS monthly_revenue,
    SUM(Profit) AS monthly_profit,
    COUNT(DISTINCT "Order ID") AS number_of_orders,
    AVG(Sales) AS average_order_value
FROM superstore
GROUP BY order_year, order_month
ORDER BY order_year, order_month;


-- ====================================================================
-- Step 4: Growth Trend Analysis
-- Let's analyze month-over-month growth to understand business performance.
-- We will use a Common Table Expression (CTE) and a Window Function (LAG).
-- ====================================================================

WITH MonthlyMetrics AS (
    SELECT
        DATE_TRUNC('month', "Order Date")::DATE AS report_month, -- For PostgreSQL
        -- For other DBs, you might need to combine YEAR() and MONTH()
        -- e.g., CAST(CONCAT(EXTRACT(YEAR FROM "Order Date"), '-', EXTRACT(MONTH FROM "Order Date"), '-01') AS DATE)
        SUM(Sales) AS total_sales
    FROM superstore
    GROUP BY report_month
)
SELECT
    report_month,
    total_sales,
    -- Get the previous month's sales using the LAG window function
    LAG(total_sales, 1, 0) OVER (ORDER BY report_month) AS previous_month_sales,
    -- Calculate the month-over-month growth percentage
    (total_sales - LAG(total_sales, 1, 0) OVER (ORDER BY report_month)) / LAG(total_sales, 1, 0) OVER (ORDER BY report_month) * 100 AS mom_growth_percentage
FROM MonthlyMetrics
ORDER BY report_month;


-- ====================================================================
-- Step 5: Report Automation Simulation
-- To simulate automation, we can create a VIEW. A view is a stored
-- query that can be accessed like a table. Business intelligence
-- tools can connect to this view, and it will always return fresh data.
-- ====================================================================

CREATE OR REPLACE VIEW V_MonthlyFinancialSummary AS
SELECT
    EXTRACT(YEAR FROM "Order Date") AS order_year,
    EXTRACT(MONTH FROM "Order Date") AS order_month,
    SUM(Sales) AS monthly_revenue,
    SUM(Profit) AS monthly_profit,
    COUNT(DISTINCT "Order ID") AS number_of_orders,
    AVG(Sales) AS average_order_value
FROM superstore
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- Now you can query the view directly to get your monthly report
SELECT * FROM V_MonthlyFinancialSummary;
