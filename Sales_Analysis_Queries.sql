-- =============================================================
-- Sales Performance Dashboard - SQL Business Analysis
-- Database: sales_analysis
-- Table: sales_data
-- Imported dataset: 150 orders
-- =============================================================

USE sales_analysis;

-- Q1. Overall business KPIs
SELECT
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    SUM(Quantity) AS Total_Units_Sold,
    ROUND(AVG(Sales_INR), 2) AS Average_Order_Value_INR,
    ROUND(SUM(Profit_INR) / NULLIF(SUM(Sales_INR), 0) * 100, 2) AS Profit_Margin_Pct
FROM sales_data;

-- Q2. Monthly sales and profit trend
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
    ROUND(SUM(Sales_INR), 2) AS Monthly_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Monthly_Profit_INR,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Sales_Month;

-- Q3. Sales and profit by region
SELECT
    Region,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY Region
ORDER BY Total_Sales_INR DESC;

-- Q4. Category performance
SELECT
    Category,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    SUM(Quantity) AS Units_Sold
FROM sales_data
GROUP BY Category
ORDER BY Total_Profit_INR DESC;

-- Q5. Sales channel contribution
SELECT
    Sales_Channel,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Sales_INR) / (SELECT SUM(Sales_INR) FROM sales_data) * 100, 2) AS Sales_Contribution_Pct,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY Sales_Channel
ORDER BY Total_Sales_INR DESC;

-- Q6. Top 10 products by sales
SELECT
    Product,
    Category,
    SUM(Quantity) AS Units_Sold,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR
FROM sales_data
GROUP BY Product, Category
ORDER BY Total_Sales_INR DESC
LIMIT 10;

-- Q7. Customer segment performance
SELECT
    Customer_Segment,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    ROUND(AVG(Sales_INR), 2) AS Average_Order_Value_INR
FROM sales_data
GROUP BY Customer_Segment
ORDER BY Total_Sales_INR DESC;

-- Q8. State-wise sales performance (top 10)
SELECT
    State,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_data
GROUP BY State
ORDER BY Total_Sales_INR DESC
LIMIT 10;

-- Q9. Sub-category performance
SELECT
    Category,
    Sub_Category,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    SUM(Quantity) AS Units_Sold
FROM sales_data
GROUP BY Category, Sub_Category
ORDER BY Total_Profit_INR DESC;

-- Q10. Discount band analysis
SELECT
    CASE
        WHEN Discount_Pct = 0 THEN 'No Discount'
        WHEN Discount_Pct <= 0.05 THEN 'Above 0% - 5%'
        WHEN Discount_Pct <= 0.10 THEN 'Above 5% - 10%'
        ELSE 'Above 10%'
    END AS Discount_Band,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(Sales_INR), 2) AS Average_Sales_INR,
    ROUND(AVG(Profit_INR), 2) AS Average_Profit_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR
FROM sales_data
GROUP BY Discount_Band
ORDER BY MIN(Discount_Pct);

-- Q11. Profit margin by category
SELECT
    Category,
    ROUND(SUM(Sales_INR), 2) AS Total_Sales_INR,
    ROUND(SUM(Profit_INR), 2) AS Total_Profit_INR,
    ROUND(SUM(Profit_INR) / NULLIF(SUM(Sales_INR), 0) * 100, 2) AS Profit_Margin_Pct
FROM sales_data
GROUP BY Category
ORDER BY Profit_Margin_Pct DESC;

-- Q12. Data quality checks: duplicate order IDs and missing key values
SELECT
    COUNT(*) AS Total_Rows,
    COUNT(DISTINCT Order_ID) AS Distinct_Order_IDs,
    SUM(Order_ID IS NULL OR Order_ID = '') AS Missing_Order_IDs,
    SUM(Order_Date IS NULL) AS Missing_Order_Dates,
    SUM(Sales_INR IS NULL) AS Missing_Sales_Values,
    SUM(Profit_INR IS NULL) AS Missing_Profit_Values
FROM sales_data;

-- Q13. Reconciliation check: compare calculated sales and profit checks
SELECT
    Sales_Check,
    Profit_Check,
    COUNT(*) AS Row_Count
FROM sales_data
GROUP BY Sales_Check, Profit_Check
ORDER BY Row_Count DESC;

-- Q14. Largest individual orders by sales
SELECT
    Order_ID,
    Order_Date,
    Customer_Segment,
    Region,
    Product,
    Quantity,
    ROUND(Sales_INR, 2) AS Sales_INR,
    ROUND(Profit_INR, 2) AS Profit_INR
FROM sales_data
ORDER BY Sales_INR DESC
LIMIT 10;
