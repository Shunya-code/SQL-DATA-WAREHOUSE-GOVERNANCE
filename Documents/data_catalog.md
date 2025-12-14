Data Dictionary for Gold Layer 
-----------------------------------------------------------------------------------------------------------------
Overview
-----------------------------------------------------------------------------------------------------------------
The Gold Layer is the business-level data representation,structured to support analytical and reporting use cases.
It consists of dimension tables and faxct tables for specific business metrics.
-----------------------------------------------------------------------------------------------------------------
1.Gold.dim_customers 
 .Purprose:Stores Customer details enriched with demographic and geographic data.
 .Columns :
 
 
 | Column  Name    |    Data Type      |               Description                                                                                                    |
 |   ---           |        ---        |               ---                                                               | 
 | customer_key    |   INT             | Surrogate key uniquely identifying each customer record in the dimension table  |
 | cutomer_id      |   INt             | Unique nuerical identifier assigned to each customer.                           |
 | customer_number |  NVRCHAR(50)      | Alphanumeric identifier assigned to each customer,used for tracking or refernce.|
 | first_name      |  NVARCHAR(50)     | The customers first name as recorded in the system.                             |
 | last_name       |  NVARCHAR(50)     | The customers last name or family name .                                        |
 | country         |  NVARCHAR(50)     | THe country of residence for the customers .(e.g 'Australia')                   |
 | marital_status  |  NVARCHAR(50)     | The marital status of the customer (e.g Married or Single)                      |
 | gender          |  NVARCHAR(50)     | The gender of the customer (e.g 'Female','Male','N/A')                                |
 | birthdate       |  DATE             | the date of the birth of the customer,formatted as  yyyy-mm-dd (e.g 1971-10-06) |
 | create_date     |  DATE             | The date and time when the customwe record was created in the system            |
 
 
 
 2.gold.dim_products
  .Purpose: Provides information about products and attributes 
  . Columns

 
 | Column  Name         |    Data Type      |               Description                                                                                                    |
 |   ---                |        ---        |               ---                                                                                   | 
 | product_key          |  INT              | Surrogate key uniquely identifying each product  record in the product dimension table              |
 | product_id           |  INT              | Unique nuerical identifier assigned to each product for internal tracking and referencing.          |
 | product_number       |  NVRCHAR(50)      | A structure  Alphanumeric code representing the product ,often used for categorization of inventory |
 | product_name         |  NVARCHAR(50)     | Descriptive name of the product ,including key details such as type,color,size                      |
 | category_id          |  NVARCHAR(50)     | A Unique identifier for the products category ,linking to high level classification.                |
 | category             |  NVARCHAR(50)     | The broader classification of products within the category ,such as product type                    |
 | subcategory          |  NVARCHAR(50)     | A more detailed classification of the product within the category,such as product type.             |                             |
 | maintenence_required |  NVARCHAR(50)     | Indicates whether the product requires maintennce  (e.g Yes,No)                                     |
 | cost                 |  INT              | The Cost or base price of the product ,measured in monetary units .                                 |
 | product_line         |  NVARCHAR(50)     | The specific product line or series to which the product belongs (e.g Road,Monutains)               |
 | start_date           |  DATE             | The date when the product became available 



3.gold.fact_sales
 .Purpose : Stores transactional sales data for analytical purposes.
 .Columns


 
 | Column  Name         |    Data Type      |               Description                                                                           |
 |   ---                |        ---        |               ---                                                                                   | 
 | order_number         |  NVARCHAR(50)     | A unique alphanumeric identifier for each sales (e.g 'SO54496').                                    |
 | product_key          |  INT              | Surrogate key linking the order to the  product dimension table                                     |
 | customer_key         |  INT              | Surrogate key linking the order to the consumer dimension table                                     |
 | order_date           |  DATE             | The date when the order was placed                                                                  |
 | shipping_date        |  DATE             | The date when the order was shipped to the customer                                                 |
 | due_date             |  DATE             | The date when the order payment was due                                                             |
 | sales_amount         |  INT              | THe total monetary value of the sale for the line item .in whole currency units (e.g 25)            |                             
 | quantity             |  INT              | The number of units of the product ordered for the line item (e.g  1)                               |
 | price                |  INT              | The price unit of the product for the line item ,in whole currency units e.g 25)                    |        









 
