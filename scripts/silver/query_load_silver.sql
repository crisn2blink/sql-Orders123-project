/*
=======================================
SILVER LAYER 
=======================================
SCRIPT PURPOSE:
--This script loads data from the "bronze" schema into the silver layer.
------------------------------------------------------------------------
||WARNING: DO NOT RUN THIS SCRIPT AGAIN ONCE IT HAS ALREADY BEEN RUN||
-It will simply insert all the data into the table again (creating all duplicates)

*THIS TABLE HAS AN IDENTITY KEY WHICH WILL BE REPOPULATED IF THE TABLE HAS TO BE RE-CREATED
-Meaning that the records might have different identity keys.

*FOR PROTECTION PURPOSES, THE "INSERT INTO" FUNCTION HAS BEEN SEALED AS A COMMENT
-------------------------------------------------------------------------
*/
/*INSERT INTO silver.gpt_orders_123(
    order_id,
    sale_date,
    product_name,
    price,
    quantity,
    sales_person,
    region
)*/
    SELECT
        CASE
            WHEN NULLIF(TRIM(o.order_id), '') IS NULL THEN NULL
            WHEN TRIM(o.order_id) = 'A102' THEN 102
            WHEN UPPER(TRIM(o.order_id)) = 'ONE_THOUSAND' THEN 1000
            WHEN UPPER(TRIM(o.order_id)) = 'ORD-55' THEN 55
            ELSE TRY_CAST(TRIM(o.order_id) AS INT)
        END AS order_id,
        COALESCE(
            TRY_CONVERT(date, o.sale_date, 23),   -- yyyy-mm-dd
            TRY_CONVERT(date, o.sale_date, 105),  -- dd-mm-yyyy
            TRY_CONVERT(date, o.sale_date, 103),  -- dd/mm/yyyy
            TRY_CONVERT(date, o.sale_date, 101)   -- mm/dd/yyyy (optional but common)
        ) AS sale_date,
        CASE
            WHEN TRIM(o.product_name) = 'Moniter' THEN 'Monitor'
            WHEN TRIM(o.product_name) = 'Laptoop' THEN 'Laptop'
            WHEN TRIM(o.product_name) = 'USB C Cable' THEN 'USB-C Cable'
            WHEN TRIM(o.product_name) = 'Keybord' THEN 'Keyboard'
            ELSE TRIM(o.product_name)
        END AS product_name,
        CASE 
            WHEN TRIM(o.price) IN ('unknown', 'free', 'N/A', '') THEN NULL
            ELSE TRY_CAST(
                NULLIF(
                    TRIM(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(TRIM(o.price), 'USD $', ''),
                                    'USD ', ''),
                                '$', ''),
                            ',', ''),
                        '-','')
                    ),
                '')
            AS FLOAT)
        END AS price,
        CASE
            WHEN NULLIF(TRIM(o.quantity), '') IS NULL THEN NULL
            WHEN TRIM(o.quantity) = 'five' THEN 5
            WHEN TRIM(o.quantity) = 'ten' THEN 10
            WHEN TRIM(o.quantity) IN('N/A', '0') THEN NULL
            WHEN q.quantity_cross IS NOT NULL THEN TRY_CAST(ROUND(ABS(q.quantity_cross),0) AS INT)
            ELSE NULL
        END AS quantity,
        CASE
            WHEN NULLIF(TRIM(o.sales_person), '') IS NULL THEN 'n/a'
            WHEN TRIM(o.sales_person) = 'Carlos M.' THEN 'Carlos Martinez'
            WHEN TRIM(o.sales_person) = 'Diana-Lee' THEN 'Diana Lee'
            WHEN TRIM(o.sales_person) = 'A. Johnson' THEN 'Alice Johnson'
            ELSE o.sales_person
        END AS sales_person,
        CASE
            WHEN NULLIF(TRIM(o.region), '') IS NULL THEN 'n/a'
            WHEN TRIM(o.region) = 'E' THEN 'East'
            WHEN TRIM(o.region) = 'West Coast' THEN 'West'
            WHEN UPPER(TRIM(o.region)) ='NORTH' THEN 'North'
            WHEN UPPER(TRIM(o.region)) ='EAST' THEN 'East'
            WHEN UPPER(TRIM(o.region)) ='WEST' THEN 'West'
            WHEN UPPER(TRIM(o.region)) ='SOUTH' THEN 'South'
            ELSE o.region
        END AS region
    FROM bronze.gpt_orders_123 AS o
    CROSS APPLY(
            SELECT TRY_CAST(TRIM(o.quantity) AS DECIMAL(10,4)) AS quantity_cross
        ) AS q
