{{
    config(
        materialized='view'
    )
}}

WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['event_id'])}} AS event_id,
      page_url,
      event_type,
      {{ dbt_utils.generate_surrogate_key(['user_id'])}} AS user_id,
      {{ dbt_utils.generate_surrogate_key(['product_id'])}} AS product_id,
      {{ dbt_utils.generate_surrogate_key(['session_id'])}} AS session_id,
      CONVERT_TIMEZONE('UTC', CAST(created_at AS timestamp_tz)) AS created_at,
      {{ dbt_utils.generate_surrogate_key(['order_id'])}} AS order_id,
      _fivetran_deleted,
      CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM src_events
)
SELECT * FROM renamed_casted