{{
  config(
    materialized='view'
  )
}}

WITH source AS (
    SELECT 
        *
    FROM {{ source('fish_data', 'fish') }}
),

renamed AS (
    select
        {{ dbt_utils.generate_surrogate_key(['fish_id'])}} AS fish_id,
        nombre_cientifico,
        nombre_descriptor,
        CAST(anio_descripcion + '-01-01' AS DATE) AS anio_descripcion,
        status_iucn,
        {{ dbt_utils.generate_surrogate_key(['genero'])}} AS genero_id,
        tipo_agua,
        CAST(SUBSTRING(tamamio_medio, 1, POSITION(' ' IN tamamio_medio) - 1) AS INT) AS tamamio_medio_cm,
        CAST(SUBSTRING(tamanio_maximo, 1, POSITION(' ' IN tamanio_maximo) - 1) AS INT) AS tamanio_maximo_cm,
        CASE
            WHEN longevidad IN 'no data' THEN 2
            ELSE CAST(SUBSTRING(longevidad, 1, POSITION(' ' IN longevidad) - 1) AS INT)
        END AS longevidad_anios,
        forma,
        SUBSTRING(dieta, 1, POSITION(' ' IN dieta) - 1) AS dieta,
        sociabilidad,
        CASE
            WHEN territorial IN 'Sí' THEN true
            WHEN territorial IN 'No' THEN false
            ELSE false
        END AS territorial_bool,
        modo_de_vida,
        reproduccion,
        {{ dbt_utils.generate_surrogate_key(['pais'])}} AS pais_id,
        rio,
        CAST(SUBSTRING(temperatura, 1, POSITION('-' IN temperatura) - 1) AS INT) AS temperatura_minima_origen,
        CAST(SUBSTRING(
            SUBSTRING(temperatura, POSITION('-' IN temperatura) + 1), 
            1, 
            POSITION('º' IN SUBSTRING(temperatura, POSITION('-' IN temperatura) + 1)) - 1
        ) AS INT) AS temperatura_maxima_origen,
        CAST(SUBSTRING(ph, 1, POSITION('-' IN ph) - 1) AS INT) AS ph_minimo_origen,
        CAST(SUBSTRING(ph, POSITION('-' IN ph) + 1) AS INT) AS ph_maximo_origen,
        CAST(SUBSTRING(gh, 1, POSITION('-' IN gh) - 1) AS INT) AS gh_minimo_origen,
        CAST(SUBSTRING(gh, POSITION('-' IN gh) + 1) AS INT) AS gh_maximo_origen,
        corriente,
        CAST(SUBSTRING(volumen_minimo, 1, POSITION(' ' IN volumen_minimo) - 1) AS INT) AS volumen_minimo_litros,
        poblacion_minima::INT,
        CAST(SUBSTRING(temperatura_acuario, 1, POSITION('-' IN temperatura_acuario) - 1) AS INT) AS temperatura_acuario_minimo,
        CAST(SUBSTRING(
            SUBSTRING(temperatura_acuario, POSITION('-' IN temperatura_acuario) + 1), 
            1, 
            POSITION('º' IN SUBSTRING(temperatura_acuario, POSITION('-' IN temperatura_acuario) + 1)) - 1
        ) AS INT) AS temperatura_acuario_maximo,
        ph_acuario,
        CAST(SUBSTRING(ph_acuario, 1, POSITION('-' IN ph_acuario) - 1) AS INT) AS ph_acuario_minimo_origen,
        CAST(SUBSTRING(ph_acuario, POSITION('-' IN ph_acuario) + 1) AS INT) AS ph_acuario_maximo_origen,
        dificultad,
        robustez,
        comportamiento,
        CASE
            WHEN disponibilidad IN 'no data' THEN 'rare',
            ELSE disponibilidad
        END AS disponibilidad
    from source
)

select * from renamed