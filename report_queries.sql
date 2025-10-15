


SELECT * FROM superstore LIMIT 10;
SELECT
    MIN("Order Date") AS first_order_date,
    MAX("Order Date") AS last_order_date
FROM superstore;
SELECT
    SUM(Sales) AS total_revenue,
    SUM(Profit) AS total_profit,
    (SUM(Profit) / SUM(Sales)) * 100 AS overall_profit_margin_percentage
FROM superstore;

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
WITH MonthlyMetrics AS (
    SELECT
        DATE_TRUNC('month', "Order Date")::DATE AS report_month, 
       
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

SELECT * FROM V_MonthlyFinancialSummary;


