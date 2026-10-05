-- =================================================================================
-- OLIST E-COMMERCE MARKETPLACE: EXECUTIVE KPI PERFORMANCE SCRIPT
-- Objective: Evaluate transactional habits, payment trends, and shipping timelines
-- Data Author: Varsha
-- =================================================================================

USE ecommerce;

-- 📊 KPI 1: Weekday Vs Weekend Order Volume & Purchasing Distribution
-- Business Case: Understand customer booking behavior split by day type.
SELECT
    CASE 
        WHEN DAYOFWEEK(Order_Purchase_Timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(*) AS Total_Orders
FROM orders
WHERE Order_Purchase_Timestamp IS NOT NULL
GROUP BY Day_Type;


-- 📊 KPI 2: Seamless Digital Checkouts (High-Satisfaction Credit Transactions)
-- Business Case: Isolate the total count of frictionless 5-star order fulfillments.
SELECT 
    COUNT(DISTINCT r.Order_Id) AS total_orders
FROM order_reviews AS r
JOIN order_payments AS p
    ON r.Order_Id = p.Order_Id
WHERE r.Review_Score = 5
  AND p.Payment_Type = 'credit_card';


-- 📊 KPI 3: Logistical Timelines — Average Processing Window for 'Pet Shop' Verticals
-- Business Case: Benchmarks real delivery intervals against specific product sectors.
SELECT 
    ROUND(AVG(DATEDIFF(o.Order_Delivered_Customer_Date, o.Order_Purchase_Timestamp)), 1) AS avg_delivery_days
FROM orders o
JOIN order_items oi 
    ON o.Order_Id = oi.Order_Id
JOIN products p 
    ON oi.Product_Id = p.Product_Id
WHERE p.Product_category_name = 'pet_shop'
  AND o.Order_Delivered_Customer_Date IS NOT NULL
  AND o.Order_Purchase_Timestamp IS NOT NULL;


-- 📊 KPI 4: Macro Regional Value Concentration — São Paulo Demographic Metrics
-- Business Case: Profiles asset pricing and total payments inside major economic centers.
SELECT
    ROUND(AVG(oi.Price), 2) AS avg_product_price,
    ROUND(AVG(p.Payment_Value), 2) AS avg_payment_value
FROM customer c
JOIN orders o
    ON c.Customer_Id = o.Customer_Id
JOIN order_items oi
    ON o.Order_Id = oi.Order_Id
JOIN order_payments p
    ON o.Order_Id = p.Order_Id
WHERE LOWER(c.City) = 'sao paulo';


-- 📊 KPI 5: Correlation Study — Shipping Turnaround Window vs Final Review Score
-- Business Case: Proves mathematically to leadership how fulfillment speeds protect user retention.
SELECT 
    r.Review_Score,
    ROUND(AVG(DATEDIFF(o.Order_Delivered_Customer_Date, o.Order_Purchase_Timestamp)), 1) AS avg_shipping_days,
    COUNT(*) AS total_reviews
FROM order_reviews r
JOIN orders o
    ON r.Order_Id = o.Order_Id
WHERE o.Order_Delivered_Customer_Date IS NOT NULL
  AND o.Order_Purchase_Timestamp IS NOT NULL
GROUP BY r.Review_Score
ORDER BY r.Review_Score DESC;
