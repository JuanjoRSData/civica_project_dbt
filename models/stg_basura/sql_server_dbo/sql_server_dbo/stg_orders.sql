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
      {{ dbt_utils.generate_surrogate_key(['order_id'])}} AS order_id,
      shipping_service,
      shipping_cost,
      {{ dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id,
      CONVERT_TIMEZONE('UTC', CAST(created_at AS timestamp_tz)) AS created_at,
      CONVERT_TIMEZONE('UTC', CAST(created_at AS timestamp_tz))::DATE AS date_created_at,
      {{ dbt_utils.generate_surrogate_key(['promo_id'])}} AS promo_id,
      CONVERT_TIMEZONE('UTC', CAST(estimated_delivery_at AS timestamp_tz)) AS estimated_delivery_at,
      CONVERT_TIMEZONE('UTC', CAST(created_at AS timestamp_tz))::DATE AS date_estimated_delivery_at,
      order_cost,
      {{ dbt_utils.generate_surrogate_key(['user_id'])}} AS user_id,
      order_total,
      CONVERT_TIMEZONE('UTC', CAST(delivered_at AS timestamp_tz)) AS delivered_at,
      {{ dbt_utils.generate_surrogate_key(['tracking_id'])}} AS tracking_id,
      status,
      _fivetran_deleted,
      CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM  src_orders  

)
SELECT * FROM renamed_casted