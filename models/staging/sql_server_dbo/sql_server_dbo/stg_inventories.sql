{{
    config(
        materialized='view'
    )
}}

WITH src_inventory AS (
    SELECT 
        *,
        CURRENT_DATE() AS actual_date
    FROM {{ source('sql_server_dbo', 'products')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['product_id', 'actual_date'])}} AS inventory_id,
      inventory AS product_stock,
      actual_date AS date_id,
    FROM  src_products  
)
SELECT * FROM renamed_casted