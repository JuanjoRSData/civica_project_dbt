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

    WITH parametros_busqueda AS (
        SELECT 
            7 AS ph_deseado,  
            10 AS gh_deseado     
    )
    SELECT 
        f.NOMBRE_CIENTIFICO,
        f.PH_MINIMO_ORIGEN,
        f.PH_MAXIMO_ORIGEN,
        f.GH_MINIMO_ORIGEN,
        f.GH_MAXIMO_ORIGEN,
        f.TEMPERATURA_MINIMA_ORIGEN,
        f.TEMPERATURA_MAXIMA_ORIGEN,
        f.TAMANIO_MEDIO_CM,
        f.DIFICULTAD,
        CASE 
            WHEN p.ph_deseado BETWEEN f.PH_MINIMO_ORIGEN AND f.PH_MAXIMO_ORIGEN 
                AND p.gh_deseado BETWEEN f.GH_MINIMO_ORIGEN AND f.GH_MAXIMO_ORIGEN
            THEN 'Compatible'
            ELSE 'No compatible'
        END AS compatibilidad,
        ABS(p.ph_deseado - (f.PH_MINIMO_ORIGEN + f.PH_MAXIMO_ORIGEN)/2) AS desviacion_ph,
        ABS(p.gh_deseado - (f.GH_MINIMO_ORIGEN + f.GH_MAXIMO_ORIGEN)/2) AS desviacion_gh
    FROM 
        source_fish f
    CROSS JOIN 
        parametros_busqueda p
    WHERE 
        p.ph_deseado BETWEEN f.PH_MINIMO_ORIGEN AND f.PH_MAXIMO_ORIGEN
        AND p.gh_deseado BETWEEN f.GH_MINIMO_ORIGEN AND f.GH_MAXIMO_ORIGEN
    ORDER BY 
        desviacion_ph + desviacion_gh ASC

)
select * from renamed










