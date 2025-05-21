{{
  config(
    materialized='table'
  )
}}

with 

source_pais as (

    select * from {{ ref('stg_fish_data__paises') }}

),

source_fish as (

    select * from {{ ref('stg_fish_data__fish') }}

),

renamed as (

    SELECT 
        f.pais_id,
        p.nombre,
        COUNT(DISTINCT FISH_ID) AS cantidad_especies,
        ROUND(AVG((PH_MAXIMO_ORIGEN + PH_MINIMO_ORIGEN) / 2), 2) AS rango_ph_promedio,
        ROUND(AVG((TEMPERATURA_MAXIMA_ORIGEN + TEMPERATURA_MINIMA_ORIGEN) / 2), 2) AS rango_temp_promedio,
        ROUND(AVG((GH_MAXIMO_ORIGEN + GH_MINIMO_ORIGEN) / 2), 2) AS rango_gh_promedio
    FROM 
        source_fish f
    JOIN source_pais p
    ON f.pais_id = p.pais_id
    WHERE 
        f.PAIS_ID IS NOT NULL
    GROUP BY 
        f.pais_id,
        p.nombre
    ORDER BY 
        cantidad_especies DESC
    LIMIT 20

)
select * from renamed




