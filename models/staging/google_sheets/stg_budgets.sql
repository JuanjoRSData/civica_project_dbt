{{
    config(
        materialized='view'
    )
}}

WITH src_budgets AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget')}}
),
renamed_casted AS (
    SELECT 
        {{ dbt_utils.generate_surrogate_key(['month','product_id'])}} AS budget_id,
        quantity,
        {{ dbt_utils.generate_surrogate_key(['product_id'])}} AS product_id,
        month,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM  src_budgets  
)
SELECT * FROM renamed_casted