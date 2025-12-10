/*
======================================================================================================
Stored procedure : Load Silver layer (Bronze > Silver)
======================================================================================================
Script Purpose :
    this stored procedure performs the ETl (extract,transform and load  ) process to populate the silver 
 schema tables form the  bronze schema.

Actions Performed:
 -- Truncates Silver tables.
 -- Insert transformed and cleansed data from bronze into silver tables.

Parameters :
    None.
    This stored procedure does not accept any parameters or retuernany values.

Usage Example :
Exec silver.load_silver
======================================================================================================
*/
Create or alter Procedure silver.load_silver as
Begin
	 Declare @start_time Datetime ,@end_time DateTime ,@batch_start_time DATETIME,@batch_end_time DATETIME ;
	 BEGIN TRY
		 set @batch_start_time =GETDATE();
		 print '======================================================================';
	     print 'Loading Silver Layer';
		 print '======================================================================';
	     
		 print '----------------------------------------------------------------------';
		 print 'LOAD CRM TABLES';
		 print '----------------------------------------------------------------------';
		 
		 --- Loading silver.crm_sales_details
		 set @start_time=GETDATE();
		 print ' >>Truncating Table silver.crm_sales_details';
		 Truncate table silver.crm_sales_details ;
		 print '>> Inserting Data Into : silver.crm_sales_details';
		 Insert Into silver.crm_sales_details (
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_price,
			sls_quantity
		) 
		select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			case 
				when sls_order_dt= 0 or len(sls_order_dt)!=8 then null
				else Cast(cast(sls_order_dt AS varchar) as Date)
			end as sls_order_dt,
			case 
				when sls_ship_dt = 0 or len(sls_ship_dt)!=8 then null 
				else cast(cast(sls_ship_dt  as varchar ) as date)
			end as sls_ship_dt,
			case 
				when sls_due_dt = 0 or len(sls_due_dt)!=8 then null 
				else cast(cast(sls_due_dt as varchar)as date)
			end as sls_due_dt,
			case 
				when sls_sales is null or sls_sales < =0 or sls_sales!=sls_quantity*abs(sls_price)
				then sls_quantity*abs(sls_price)
				else sls_sales
			end as sls_sales ,
			case 
				when sls_price is null or sls_price<=0
				then sls_sales/NULLIF(sls_quantity,0)
				else sls_price
			end as sls_price,
			sls_quantity 
		from bronze.crm_sales_details;
		set @end_time=GETDATE();
		print '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) as nvarchar) + 'seconds' ;
		print '>> ------------------------------------------------------------------------------------';


		------------------------------------------------------------------
		----copying the data form the bronze to the silver layer 
		print '---------------------------------------------------------------------------------------';
		print 'Loading data into crm product info'
		print '---------------------------------------------------------------------------------------';
		
		set @start_time =GetDate(); 
		print '>>Truncate Table Crm Prd Info ';
        Truncate Table silver.crm_prd_info ;
		print '>>Insert into silver crm prd info ';
			Insert into silver.crm_prd_info 
			(
				prd_id,
				cat_id,
				prd_key,
				prd_nm,	
				prd_cost,
				prd_line,
				prd_start_dt,
				prd_end_dt
			)
		Select  prd_id,
				replace(substring(prd_key,1,5 ),'-','_') as cat_id,
				substring(prd_key,7,len(prd_key)) as prd_key,
				prd_nm,
				isnull(prd_cost,0) as prd_cost,
				case
					when upper(trim(prd_line))='M' Then  'Mountain'
					when upper(trim(prd_line))='R' Then 'Road'
					when upper(trim(prd_line))='S' Then 'Other Sales'
					when upper(trim(prd_line))='T' then 'Touring'
				end as prd_line, 
				cast (prd_start_dt as Date ) as prd_start_dt,
				cast (lead(prd_start_dt) over 
					(partition by prd_key order by prd_start_dt)-1  as date ) as prd_end_dt
		from bronze.crm_prd_info;
		set @end_time=GetDATE();
		print '>> Load Duration : '+cast(datediff(second,@start_time,@end_time) as nvarchar)+ 'seconds ' ;
		print '----------------------------------------------------------------------------------------';
		-------------------------------------------------------------------------------------------------------------------------------
		
		print '-----------------------------------------------------------------------------------------';
		print 'Load into Crm Cust info ';
		print '-----------------------------------------------------------------------------------------';
		set @start_time =GetDate();
		print '>> Truncating Table :silver.crm_cust_info';
		truncate table silver.crm_cust_info;
		print '>> Inserting Data Into :silver.crm_cust_info';
		Insert into silver.crm_cust_info 
			(	
				cst_id,
				cst_key,
				cst_firstname,
				cst_lastname,
				cst_gndr,
				cst_marital_status,
				cst_create_date
			)
		select 
			cst_id,
			cst_key,
			trim(cst_firstname) as cst_firstname,
			trim(cst_lastname) as cst_lastname,
			case 
				when Upper(trim(cst_gndr))= 'M' then 'Male'
				when Upper(trim(cst_gndr))= 'F' then 'Female'
				else 'n/a'
			end cst_gndr,-- Normalize gender values to readable format
			case when upper(trim(cst_marital_status))='M' then 'Married'
				 when upper(trim(cst_marital_status))='S' then 'Single'
				 else 'n/a' 
				 end cst_marital_status,--Normalize marital_status to readable format
			cst_create_date
		from 
		(
			select 
				*, 
				row_number() over 
					(partition by cst_id 
					order by cst_create_date 
					desc) 
				as flag_last
				from bronze.crm_cust_info
				where cst_id is not null)t
				where flag_last=1;---select the most recent record per customer
				set @end_time=GETDATE();
				print 'Load Time :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';



		
		print '-------------------------------------------------------------------------------------------';
		print  'Loading  Erp Tables'
		print  '------------------------------------------------------------------------------------------';
		
		print  '------------------------------------------------------------------------------------------';
		print  'Loading into Erp Cust az12';
		print  '------------------------------------------------------------------------------------------';
		
		-----Inserting cleaned data into erp cust az12
		set @start_time = getDate();
		print '>> Truncate table: silver.erp_cust_az12';
		Truncate Table silver.erp_cust_az12;
		print '>> Insert Data Into : Silver.crp_cust_az12 ';
		Insert into silver.erp_cust_az12
			(
			cid,
			bdate,
			gen
			)
		select 
			case 
				when cid like 'NAS%' then Substring(cid,4,len(cid))
				else cid
			end as cid,
			case when bdate>getdate() then null 
				else bdate 
			end as bdate,
			case 
				when upper(trim(gen)) in ('F','Female') then 'Female'
				when upper(trim(gen)) in ('M','Male') then 'Male'
				else 'N/A'
			end as bdate
		from bronze.erp_cust_az12;
		set @end_time = Getdate();
		print 'Load Duration :'+cast(Datediff(second,@start_time,@end_time) as nvarchar) +'Seconds';
		print '-------------------------------------------------------------------------------------------';

		----------------------------------------------------------------------------

		print '-------------------------------------------------------------------------------------------';
		print 'Loading data into silver erp loc a101 ';
		print '-------------------------------------------------------------------------------------------';

		set @start_time=GetDate();
		print '>>Truncate Table: Silver.erp_loc_a101';
		Truncate table silver.erp_loc_a101;
		print '>>Inserting Data: silver.erp_loc_a101';
		Insert into silver.erp_loc_a101
			(	
			cid,
			cntry
			)
		Select 
			replace(cid,'-','') cid,
			case 
				when trim(cntry)='DE' then 'Germany'
				when trim(cntry) in ('US','USA') then 'United States'
				when trim(cntry) = '' or trim(cntry) is null then 'N/A'
				else  trim(cntry)
			end as cntry
		from bronze.erp_loc_a101;
		set @end_time=GetDate();
		print 'Loading Time :'+cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
		print '----------------------------------------------------------------------------------'



		----------------------------------------------------------------------------------------
		print '---------------------------------------------------------------------------------';
		print 'load Data into Silver erp px cat g1v2';
		print '---------------------------------------------------------------------------------';
		set @start_time =getdate();
		print '>> Truncate Table: Silver.erp_px_cat_g1v2';
		Truncate table  silver.erp_px_cat_g1v2;
		print '>>Inserting Data: Silver.erp_px_cat_g1v2 ';
		Insert into silver.erp_px_cat_g1v2
				(
				id,
				cat,
				subcat,
				maintenance)
		select	
				id,
				cat,
				subcat,
				maintenance 
		from bronze.erp_px_cat_g1v2;
		set @end_time=Getdate();
		print 'Load Duration :'+ cast(datediff(second,@start_time,@end_time) as nvarchar) +'seconds';
		print '-----------------------------------------------------------------------------------';

		set @batch_end_time =GetDate();
		print '===============================================================================================';
		print 'Loading Silver Layer is Complete ';
		print ' -Total load Duration : '+CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) as nvarchar);
		print '===============================================================================================';

	  end try
	Begin catch 
		print '====================================================================================================';
		print 'Error Occured during Loading Silver Layer';
		print 'Error message'+ Error_message();
		print 'Error Message '+cast (Error_Number() as nvarchar);
		print 'Error Message '+cast (Error_state () as nvarchar);
		print '====================================================================================================';         
	End catch

End;
