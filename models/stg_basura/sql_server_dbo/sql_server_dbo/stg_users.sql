{{
    config(
        materialized='view'
    )
}}

WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['user_id'])}} AS user_id,
      CONVERT_TIMEZONE('UTC', CAST(updated_at AS timestamp_tz)) AS updated_at,
      {{ dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id,
      last_name,
      CONVERT_TIMEZONE('UTC', CAST(created_at AS timestamp_tz)) AS created_at,
      phone_number,
      first_name,
      email,
      _fivetran_deleted,
      CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load,
    FROM src_users
)
SELECT * FROM renamed_casted