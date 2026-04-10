                               -- Blinkit Grocery Sales & Customer Insights Analysis --

-- Database Setup

create database Blinkit_db;
use blinkit_db;

-- Table already created (your dataset)
select * from blinkit_data;

-- Standardizing Item Fat Content Values

SET SQL_SAFE_UPDATES = 0;

UPDATE blinkit_data
SET item_fat_content =
CASE
    WHEN item_fat_content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN item_fat_content = 'reg' THEN 'Regular'
    ELSE item_fat_content
END;

-- Q1. What is the total revenue generated?
SELECT ROUND(SUM(Total_Sales),2) AS total_revenue
FROM blinkit_data;

-- Q2. How many unique items are there?
SELECT COUNT(DISTINCT `Item Identifier`) AS total_items
FROM blinkit_data;

-- Q3. What are the different item types available?
SELECT DISTINCT `Item Type`
FROM blinkit_data;

-- Q4. What is the average sales per item?
SELECT ROUND(AVG(Total_sales),2) AS avg_sales
FROM blinkit_data;

-- Q5. What is total sales by item type?
SELECT `Item Type`, ROUND(SUM(Total_Sales),2) AS revenue
FROM blinkit_data
GROUP BY `Item Type`
ORDER BY revenue DESC;

-- Q6. Which outlet type generates the highest revenue?
SELECT `Outlet Type`, SUM(Total_Sales) AS revenue
FROM blinkit_data
GROUP BY `Outlet Type`
ORDER BY revenue DESC
LIMIT 1;

-- Q7. What is the average rating by item type?
SELECT `Item Type`, ROUND(AVG(`Rating`),2) AS avg_rating
FROM blinkit_data
GROUP BY `Item Type`
ORDER BY avg_rating DESC;

-- Q8. What is the sales distribution by fat content?
SELECT item_fat_content, SUM(Total_Sales) AS revenue
FROM blinkit_data
GROUP BY item_fat_content;

-- Q9. Top 5 best-selling items?
SELECT `Item Identifier`, SUM(Total_Sales) AS sales
FROM blinkit_data
GROUP BY `Item Identifier`
ORDER BY sales DESC
LIMIT 5;

-- Q10. How many outlets exist in each location type?
SELECT `Outlet Location Type`, COUNT(*) AS total_outlets
FROM blinkit_data
GROUP BY `Outlet Location Type`;

-- Q11. Which item type contributes the highest % to total sales?
SELECT `Item Type`,
       ROUND(SUM(Total_Sales) * 100 /
       (SELECT SUM(Total_Sales) FROM blinkit_data),2) AS contribution_percent
FROM blinkit_data
GROUP BY `Item Type`
ORDER BY contribution_percent DESC;

-- Q12. Find top-performing outlets
SELECT `Outlet Identifier`,
       SUM(Total_Sales) AS revenue
FROM blinkit_data
GROUP BY `Outlet Identifier`
ORDER BY 	`Revenue` DESC
LIMIT 5;

-- Q13. Compare sales between Low Fat and Regular items
SELECT item_fat_content,
       SUM(Total_Sales) AS revenue,
       COUNT(*) AS total_items
FROM blinkit_data
GROUP BY item_fat_content;

-- Q14. Find average sales by outlet size
SELECT `Outlet Size`,
       ROUND(AVG(Total_Sales),2) AS avg_sales
FROM blinkit_data
GROUP BY `Outlet Size`;

-- Q15. Which year had the highest outlet sales?
SELECT `Outlet Establishment Year`,
       SUM(Total_Sales) AS revenue
FROM blinkit_data
GROUP BY `Outlet Establishment Year`
ORDER BY revenue DESC
LIMIT 1;

-- Q16. Identify low-performing items (sales < average)
SELECT `Item Identifier`, Total_Sales
FROM blinkit_data
WHERE Total_Sales < (SELECT AVG(Total_Sales) FROM blinkit_data);

-- Q17. Find items with high visibility but low sales
SELECT  `Item Identifier`, `Item Visibility` Total_Sales
FROM blinkit_data
WHERE `Item Visibility` > (SELECT AVG(`Item Visibility`) FROM blinkit_data)
AND Total_Sales < (SELECT AVG(Total_Sales) FROM blinkit_data);

-- Q18. Rank items based on sales
SELECT `Item Identifier`,
       SUM(Total_Sales) AS sales,
       RANK() OVER (ORDER BY SUM(total_sales) DESC) AS rank_position
FROM blinkit_data
GROUP BY `Item Identifier`;

-- Q19. Running total of sales
SELECT `Item Identifier`,
       SUM(Total_Sales) OVER (ORDER BY `Item Identifier`) AS running_total
FROM blinkit_data;

-- Q20. Find top item in each category
SELECT *
FROM (
    SELECT `Item Type`,
          `Item Identifier`,
           SUM(Total_Sales) AS sales,
           RANK() OVER (PARTITION BY `Item Type` ORDER BY SUM(Total_Sales) DESC) AS rnk
    FROM blinkit_data
    GROUP BY `Item Type`, `Item Identifier`
) t
WHERE rnk = 1;

DESCRIBE blinkit_data;

