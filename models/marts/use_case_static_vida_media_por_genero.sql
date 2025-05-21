{{
  config(
    materialized='table'
  )
}}

with 

source_fish as (

    select * from {{ ref('stg_fish_data__fish') }}

),

renamed as (

    SELECT 
        GENERO,
        ROUND(AVG(LONGEVIDAD_ANIOS), 1) AS media_vida_anios,
        MIN(LONGEVIDAD_ANIOS) AS minima_vida,
        MAX(LONGEVIDAD_ANIOS) AS maxima_vida,
        COUNT(*) AS cantidad_especies
    FROM 
        source_fish
    WHERE 
        LONGEVIDAD_ANIOS IS NOT NULL
        AND GENERO IS NOT NULL
    GROUP BY 
        GENERO
    ORDER BY 
        media_vida_anios DESC

)
select * from renamed









