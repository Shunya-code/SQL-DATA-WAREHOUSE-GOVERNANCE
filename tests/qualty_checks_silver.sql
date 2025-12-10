/*
================================================================================================

Quality Checks

================================================================================================
Script Purpose:
      this scipt performs various quality checks for data consisitenct ,acuracy,and standarization 
across the silver schema.It includes checks for :-
    - Null or Dupliucate Primary keys.
    - unwanted spaces in the string fields.
    - Data Standardization and orders.
    - Data consistency between related fields.
    - Invalid Date ranges and orders.


Usage Notes:-
   - Run these checks after loading Silver Layer.
   - Investigate and resolve any discepancies found during checks.

==================================================================================================

*/

-- ===============================================================================================
-- Checking 'silver.crm_cust_info'
-- ===============================================================================================
-- Check for Nulls or Duplicates in primary Key
-- Expecataion : No results
Select 
    cst_id ,
    count(*)
From silver.crm_cust_info
Group By  cst_id
Having count(*) > 1 or cst_id is null;
-- ===============================================================================================
-- Checking 'silver.crm_prd_info'
-- ===============================================================================================
-- Chechk for Nulls Or Duplicates in primary Key
-- Expectation : no result 
select 
  prd_id,
  count(*)
from silver.crm_prd_info 
Group by prd_id
Having count(*)>1 or prd_id is NULL;

-- Chehck for Unwanted Spaces
-- Expectation : No results 
select 
  prd_nm
From Silver.crm_prd_info 
Where prd_nm != Trim(prd_nm);

-- Check for Nulls or Negative Values in cost
-- Expectaion : No Results
Select 
  prd_cost
From silver.crm_prd_info 
Where prd_cost < 0 
or prd_cost is NULL;




-- Data Standardization And Consistenncy 
Select Distinct 
  prd_line 
 From Silver.crm_prd_info;

-- Chehck for Invalid Date orders (Standard Date > End Date)
-- Expectation :No Results

select * 
  from silver.crm_prd_info
  where prd_end_dt <prd_start_dt;


-- ===========================================================================================
-- Checking 'silver.crm_sales_details'
-- ===========================================================================================
-- Check for Invalid Dates
-- Expectation : No Invalid Dates

select 
    NULLIF(sls_due_dt,0) as sls_due_dt
 from bronze.crm_sales_details
 where sls_due_dt <=0 
    or len(sls_due_dt) !=8
    or sls_due_dt >20500101
    or sls_due_dt <19000101
-- Check for Invalid Date Orders (order date> Shipping Date /Due Dates)
-- Expectation : No results 
  select * 
  from silver.crm_sales_details 
  where sls_order_dt >sls_ship_dt
    or sls_order_dt > sls_ship_dt ;
-- Check Data Consistency : Sales =Quantity * price 
-- Expectation : No Results 
Select Distinct 
      sls_sales,
      sls_quantity,
      sls_price
From silver.crm_sales_details
where sls_sales != sls_quantity * sls_price
    or sls_sales is NULL
    or sls_quantity is null
    or sls_price is Null
    or sls_sales <=0
    or sls_quantity<=0
order by sls_sales,sls_quantity,sls_price;




-- ================================================================================================
-- Checking 'silver.erp_cust_az12'
-- ================================================================================================
-- Identify out of Range Dates
-- Expectation : Birthdates between 1924-01-01 and Getdate() 
Slect Distinct 
  bdate 
from silver.erp_cust_az12
where bdate < '1924-01-01'
   or bdate >GETDATE();

-- Data Standardization & consistyency 
Select Distinct 
  gen
From SIlver.erp_cust_az12;

-- =================================================================================================
-- Checking silver.erp_px_cat_g1v2;
-- =================================================================================================
-- Checking for unwaranted spaces 

Select Distinct 
cntry 
from silver.erp_px_cat_g1v2
where cat ! = Trim(Cat)
 or subcat != Trim(subcat)
 or maintence != Trim(maintenence)
-- Data Standarization & consistency 
Select Distinct 
  maintenence 
from silver.erp_px_cat_g1v2;

-- ==================================================================================================
-- Checking silver.erp_loc_a101
-- ==================================================================================================
-- Data Standarization and Consistency 

Select Distinct cntry 
from silver.erp_loc_a101
order by cntry;


