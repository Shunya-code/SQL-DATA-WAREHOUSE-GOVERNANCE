/*
============================================================================================================
Quality Checks
============================================================================================================
Script Purprose :
    This script performs quality checks to validate the integrity ,consistency and accuracy of the gold layer,
    These checks include:-
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimesnion tables .
    - Validation of relationships in the data model for analytical purposes.


Usage Notes:-
         -Run the checks after loading the silver Layer.
         -Investigate and resolve any discrepancies found during the checks .
=============================================================================================================
*/
-- ==========================================================================================================
-- Chceckign 'gold.dim_customers'
-- ==========================================================================================================
-- Chehck for Uniquensess of Customer key in gold.dim_customers 
-- Expectation : No results 
Select 
      customer_key,
      count(*) as duplicate_count
from gold.dim_customers 
group by customer_key
having count(*) > 1 ;
-- ==========================================================================================================
-- Checking 'gold.fact_sales'
-- ==========================================================================================================
-- Check for Uniqueness of product key in gold.dim_products 
-- Expectation : No results 
Select 
      product_key,
      count(*) As duplicate_count 
from gold.dim_products 
group by products_key 
having count(*) > 1;
-- ===========================================================================================================
-- Checking 'gold.fact_sales'
-- ===========================================================================================================
-- Check the data model connectivity between fact and dimensions 
Select * 
      from gold.fact_sales f 
      left join gold.dim_customers c 
      on c.customer_key=f.customer_key 
      left join gold.dim_products p 
      on p.product_key = f.product_key 
      where p.product_key is null or c.customer_key is null
