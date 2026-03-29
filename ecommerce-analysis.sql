-- Author: Dionis Condurache
-- Project: E-commerce Sales Analysis
-- Tool: Google BigQuery (SQL)

-- ============================================
-- E-COMMERCE SALES ANALYSIS (OLIST DATASET)
-- ============================================

-- ============================================
-- 1. CREATE MAIN DATASET
-- ============================================

CREATE OR REPLACE TABLE `bellabeat-analysis.bellabeat_data.ecommerce_main` AS
SELECT
  o.order_id,
  o.customer_id,
  DATE(o.order_purchase_timestamp) AS order_date,
  oi.product_id,
  oi.price,
  p.product_category_name
FROM `bellabeat-analysis.bellabeat_data.orders` o
JOIN `bellabeat-analysis.bellabeat_data.order_items` oi
  ON o.order_id = oi.order_id
JOIN `bellabeat-analysis.bellabeat_data.products` p
  ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';


-- ============================================
-- 2. REVENUE OVER TIME
-- ============================================

SELECT
  FORMAT_DATE('%Y-%m', order_date) AS Month,
  ROUND(SUM(price), 2) AS TotalRevenue
FROM `bellabeat-analysis.bellabeat_data.ecommerce_main`
GROUP BY Month
ORDER BY Month;


-- ============================================
-- 3. TOP PRODUCT CATEGORIES
-- ============================================

SELECT
  product_category_name,
  ROUND(SUM(price), 2) AS TotalRevenue
FROM `bellabeat-analysis.bellabeat_data.ecommerce_main`
GROUP BY product_category_name
ORDER BY TotalRevenue DESC
LIMIT 10;


-- ============================================
-- 4. CATEGORY PERFORMANCE (VOLUME VS VALUE)
-- ============================================

SELECT
  product_category_name,
  COUNT(*) AS TotalOrders,
  ROUND(SUM(price), 2) AS TotalRevenue,
  ROUND(AVG(price), 2) AS AvgPrice
FROM `bellabeat-analysis.bellabeat_data.ecommerce_main`
GROUP BY product_category_name
ORDER BY TotalRevenue DESC
LIMIT 10;


-- ============================================
-- 5. CUSTOMER BEHAVIOR (RETENTION)
-- ============================================

SELECT
  CASE
    WHEN OrderCount = 1 THEN 'One-time'
    ELSE 'Repeat'
  END AS CustomerType,
  COUNT(*) AS NumberOfCustomers
FROM (
  SELECT
    customer_id,
    COUNT(order_id) AS OrderCount
  FROM `bellabeat-analysis.bellabeat_data.orders`
  GROUP BY customer_id
)
GROUP BY CustomerType;
