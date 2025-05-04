{{
    config(
        materialized='view'
    )
}}

WITH src_promo AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos')}}
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['promo_id'])}} AS promo_id,
      promo_id AS name,
      discount,
      status,
      _fivetran_deleted,
      _fivetran_synced AS date_load
    FROM src_promo
)
SELECT * FROM renamed_casted