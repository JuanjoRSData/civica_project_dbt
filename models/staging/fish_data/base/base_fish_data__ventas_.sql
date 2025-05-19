{{
    config(
        materialized='view'
    )
}}

WITH src_ventas AS (
    SELECT 
        *,
        CURRENT_DATE() AS actual_date 
    FROM {{ source('fish_data', 'ventas')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['venta_id'])}} AS product_id,
      CONVERT_TIMEZONE('UTC', CAST(fecha AS timestamp_tz)) AS fecha,
      CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM  src_products  
)
SELECT * FROM renamed_casted