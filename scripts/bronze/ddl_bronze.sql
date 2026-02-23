/*
===========================================================================================
DDL for all CRM environment csv files
===========================================================================================
Scrict Purpose:
  This script creates tables in the 'bronze' schema.
Since this is for a one-time analysis, there is no need to add mechanics for
actualizing the table DDL structure.
===========================================================================================
*/
--Create table for orders_123.csv
CREATE TABLE bronze.gpt_orders_123
(   
    order_id NVARCHAR(50),
    sale_date NVARCHAR(50),
    product_name NVARCHAR(50),
    price NVARCHAR(50),
    quantity NVARCHAR(50),
    sales_person NVARCHAR(50),
    region NVARCHAR(50)
)
