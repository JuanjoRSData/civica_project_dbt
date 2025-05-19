{{
    config(
        materialized='view'
    )
}}

WITH src_products AS (
    SELECT 
        *,
        CURRENT_DATE() AS actual_date 
    FROM {{ source('sql_server_dbo', 'products')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['product_id'])}} AS product_id,
      price,
      name,
      {{ dbt_utils.generate_surrogate_key(['product_id', 'actual_date'])}} AS inventory_id,
      _fivetran_deleted,
      CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM  src_products  
)
SELECT * FROM renamed_casted