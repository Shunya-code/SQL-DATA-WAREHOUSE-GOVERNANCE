--SILVER LAYER DDL 

/*
==============================================================================
DDL script: Create Silver Layer
==============================================================================
Script Purpose :

  This script creates tables in the silver schema,dropping exsisting tables  
        if they already exsist.
  Run this script to define the ddl strucutre of the silver Layer

===============================================================================
*/

#DDL Silver Layer

if OBJECT_ID('silver.crm_cust_info','U') is not  null
	drop table  silver.crm_cust_info;
create table silver.crm_cust_info(
cst_id	INT,
cst_key	NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname  NVARCHAR(50),	
cst_marital_status	NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if OBJECT_ID('silver.crm_prd_info','U') is not  null
	drop table  silver.crm_prd_info;
 create table silver.crm_prd_info (
prd_id	INT,
prd_key	NVARCHAR(50),
prd_nm	NVARCHAR(50),
prd_cost INT,	
prd_line NVARCHAR(50),	
prd_start_dt DATETIME,	
prd_end_dt DATETIME,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_sales_details','U') is not null
	drop table silver.crm_sales_details;
create table silver.crm_sales_details (
sls_ord_num	NVARCHAR(50),
sls_prd_key	NVARCHAR(50),
sls_cust_id	INT,
sls_order_dt	DATE,
sls_ship_dt	DATE,
sls_due_dt	DATE,
sls_sales	INT,
sls_quantity INT,	
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if OBJECT_ID('silver.erp_cust_az12','U') is not null
	drop table silver.erp_cust_az12;
create table silver.erp_cust_az12 (
CID	NVARCHAR(50),
BDATE DATE,
GEN NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

if OBJECT_ID('silver.erp_loc_a101','U') is not null
	drop table silver.erp_loc_a101;
create table silver.erp_loc_a101(
CID	 NVARCHAR(50),
CNTRY NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
); 


if OBJECT_ID('silver.erp_px_cat_g1v2','U') is not null
	drop table silver.erp_px_cat_g1v2;
create table silver.erp_px_cat_g1v2 
(
ID NVARCHAR(50),
CAT	NVARCHAR(50),
SUBCAT NVARCHAR(50),	
MAINTENANCE NVARCHAR(50)
);



--Some changes have taken at a later stage
-- lets modify our Silver.crm_cust_info for stability and data changes 
if object_id('silver.crm_prd_info','U') is not null
		drop table silver.crm_prd_info;
	create table Silver.crm_prd_info (
		prd_id INT,
		cat_id NVARCHAR(50),
		prd_key NVARCHAR(50),
		prd_nm NVARCHAR(50),
		prd_cost INT,
		prd_line NVARCHAR(50),
		prd_start_dt DATE,
		prd_end_dt DATE ,
		dwh_create_date DATETIME2 DEFAULT GETDATE()
	);





