{{
    config(
        materialized='view'
    )
}}

WITH src_promo AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos')}}
    UNION ALL
    SELECT 
        'sin_promocion' AS promo_id,
        0 AS discount,
        'inactive' AS status,
        null AS _fivetran_deleted,
        SYSDATE() AS date_load
),
renamed_casted AS (
    SELECT 
      {{ dbt_utils.generate_surrogate_key(['promo_id']) }} AS promo_id,
      coalesce(promo_id, 'sin_promocion') AS name,
      discount,
      status,
      _fivetran_deleted,
      CONVERT_TIMEZONE('UTC',  CAST(_fivetran_synced AS timestamp_tz)) AS date_load
    FROM src_promo
)
SELECT * FROM renamed_casted



