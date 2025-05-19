
{{
  config(
    materialized='view'
  )
}}

WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['address_id'])}} AS address_id,
        zipcode,
        country,
        address,
        state,
        _fivetran_deleted,
        CONVERT_TIMEZONE('UTC', CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM src_addresses
    )

SELECT * FROM renamed_casted