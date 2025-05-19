{{
    config(
        materialized='view'
    )
}}

WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['shipping_service'])}} AS shipping_service_id,
      shiping_service AS shipping_company_name
    FROM  src_orders  
    WHERE shipping_service IS NOT NULL

)
SELECT * FROM renamed_casted