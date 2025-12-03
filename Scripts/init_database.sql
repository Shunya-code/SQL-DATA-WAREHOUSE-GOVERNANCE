/*

======================================================================
  Create Database and Schemas
======================================================================
  Script Purpose :
    this script creates a new database named 'DataWarehouse' after checking if it already exsists.
    if the database exsists ,its is dropped and recreated .addistionally the cripts sets up three schemas 
  within the database :'bronze','silver' and 'gold'

  Warning:
    Running this script will drop your old 'Datawarehouse' database if it exsists.
    All data in the database will be permamntly deleted .proceed with caution 
  and ensure you have proper backups before running the scripots.
  */
  


USE master;
go

-----Drop and recreate 'Datawarehouse ' database
if exists (slect 1 from sys.database where name='DataWarehouse')
Begin
alter database Datawarehouse Set Singlr_user with rollBack Immediate;
drop database datawarehouse
End;
go

--Creating our 'Datawarehouse Database'
Create Database Datawarehouse;
go
Use Datawarehouse;
go
Create Schema Bronze ;
go 
Create Schema Silver;
go
Create Schema Gold;
