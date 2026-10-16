/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
-- Expectation: No results 

SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c 
ON c.customer_key = f.customer_key
WHERE c.customer_key IS NULL

-- Check the data model connectivity between fact and dimensions
-- Expectation: No results 
-- This query is more resource-intensive and complex due to the joins. 
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  

-- A lighter alternative would be: 
--(Check fact table and dimension customers table)
-- Expectation: No results 
SELECT f.*
FROM gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1 
    FROM gold.dim_customers c 
    WHERE c.customer_key = f.customer_key
);
/*
This query returns all sales records that do not have a matching customer in dim_customers. 
NOT EXISTS checks whether a matching customer exists, while SELECT 1 simply checks for the existence of a record without 
retrieving any specific column. This makes the logic simpler and can be more efficient, depending on the database 
and execution plan.
*/

--(Check fact table and dimension products table)
-- Expectation: No results 
SELECT f.*
FROM gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1 
    FROM gold.dim_products p
    WHERE p.product_key = f.product_key
);