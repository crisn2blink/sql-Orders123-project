/*
===========================================================================================
DDL for all CRM environment csv files
===========================================================================================
Scrict Purpose:
  This script creates tables in the 'silver' schema, dropping existing tables if
  they already exist.
Run this script to re-define the DDL structure of 'silver' tables
===========================================================================================
IMPORTANT NOTE: T-SQL: used in order to easily refresh the table's DDL on a as-needed basis
by dropping the table if it exists and recreating it with the most up-to-date values
from the source document.
*/

--Create table for orders_123.csv
IF OBJECT_ID ('silver.gpt_orders_123', 'U') IS NOT NULL
    DROP TABLE silver.gpt_orders_123;
CREATE TABLE silver.gpt_orders_123
(   
    sales_id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    order_id FLOAT,
    sale_date DATE,
    product_name NVARCHAR(50),
    price DECIMAL(10,2),
    quantity INT,
    sales_person NVARCHAR(50),
    region NVARCHAR(50)
)
