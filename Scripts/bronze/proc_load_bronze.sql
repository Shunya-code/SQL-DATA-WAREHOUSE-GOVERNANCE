/*
===========================================================================================
Stored Procedure : Load Bronze Layer(Source -> Bronze)
===========================================================================================
Script Purpose :
  this stored procedure loads data int the bronze schema from external 'CSV files'.
  It performs the following actions :
  - Truncates the bronze tables before loading data.
  - Uses the Bulk Insert command to load data from csv files into bronze tables.

Parameters:
  None.
This stored procedure does not accept any parameters or return any values.

Usage Ecample :
   Exec bronze.load_bronze;
=============================================================================================
*/

Execute Bronze.load_bronze;

Create or alter procedure bronze.load_bronze as 
begin
	DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME ;
	begin try
		set @batch_start_time =GETDATE();
		Print'==============================';
		print 'Loading Bronze layer';
		print '=============================';

		print '-----------------------------';
		print 'Loading CRM Tables';
		print '-----------------------------';
		
		SET @start_time=GETDATE();
		print '>> Truncate Table : bronze.crm_cust_info';
		truncate table bronze.crm_cust_info;
		print '>> Insert data into bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info 
		from "C:\Users\Ankit\OneDrive\Desktop\CRM\cust_info.csv"
		with 
		(firstrow=2,
		fieldterminator=',',
		tablock
		);
		SET @end_time=GETDATE();
		print '>> LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + 'seconds';
        print '>> --------------';

		set @start_time=GETDATE();
		print '>> Truncate Table : bronze.crm_prd_info';
		truncate table bronze.crm_prd_info;
	
		print '>> Insert data into bronze.crm_prd_info';
		Bulk insert bronze.crm_prd_info 
		from "C:\Users\Ankit\OneDrive\Desktop\CRM\prd_info.csv"
		with 
		(
		firstrow=2,
		Fieldterminator=',',
		tablock
		);
		set @end_time=GETDATE();
		print '>>LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +'seconds';
		print '>>-----------------';

		

		set @start_time=GETDATE();
		print '>> Truncate Table : bronze.crm_sales_details';
		truncate table bronze.crm_sales_details;
		print '>> Insert data into bronze.crm_sales_details';
		bulk insert bronze.crm_sales_details 
		from "C:\Users\Ankit\OneDrive\Desktop\CRM\sales_details.csv"
		with 
		(
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=GETDATE();
		print '>>LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +'seconds';
		print '>>-----------------';

		print '-----------------------------';
		print 'Loading ERP Tables';
		print '-----------------------------';
	    
		set @start_time=GETDATE();
		print '>>Truncate Table :bronze.erp_loc_a101';
		truncate table bronze.erp_loc_a101;
		print '>> Insert data into bronze.erp_loc_a101';
		bulk insert bronze.erp_loc_a101
		from "C:\Users\Ankit\OneDrive\Desktop\ERP\LOC_A101.csv" 
		with (
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=GETDATE();
		print '>>LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +'seconds';
		print '>>-----------------';

		SET @start_time=GETDATE();
		print '>>Truncate Table :bronze.erp_cust_az12';
		truncate table bronze.erp_cust_az12;
		print '>> Insert data into bronze.erp_cust_az12';
		bulk insert bronze.erp_cust_az12
		from "C:\Users\Ankit\OneDrive\Desktop\ERP\CUST_AZ12.csv"
		with 
		(
		firstrow=2,
		fieldterminator=',',
		tablock
		);
		set @end_time=GETDATE();
		print '>>LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +'seconds';
		print '>>-----------------';

		set @start_time=GETDATE();
		print '>>Truncate Table :bronze.erp_px_cat_g1v2';
		truncate table bronze.erp_px_cat_g1v2;
		print '>> Insert data into bronze.erp_px_cat_g1v2';
		bulk insert bronze.erp_px_cat_g1v2
		from "C:\Users\Ankit\OneDrive\Desktop\ERP\PX_CAT_G1V2.csv"
		with 
		(
		firstrow=2,
		fieldterminator=',',
		tablock

		);
		set @end_time=GETDATE();
		print '>>LOAD DURATION :' +CAST(DATEDIFF(second,@start_time,@end_time) as NVARCHAR) +'seconds';
		print '>>-----------------';

		set @batch_end_time =GETDATE();
		PRINT '=====================================';
		PRINT 'LOADING BRONZE LAYER IS COMPLETE';
		PRINT ' - Totlal_Load_Duration : '+CAST (DATEDIFF (second,@batch_start_time,@batch_end_time) as NVARCHAR) +'seconds' ;
		PRINT '=====================================';



	End TRY
	BEGIN CATCH
		PRINT '==================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		print 'ERROR MESSAGE'+CAST (ERROR_MESSAGE() as NVARCHAR);
		print 'ERROR MESSAGE'+CAST (ERROR_STATE() AS NVARCHAR );
		print '=================================='
	END CATCH

End;




