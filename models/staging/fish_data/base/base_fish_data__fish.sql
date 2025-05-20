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
    SELECT
        {{ dbt_utils.generate_surrogate_key(['fish_id']) }} AS fish_id,
        nombre_cientifico,
        nombre_descriptor,
        CAST(anio_descripcion || '-01-01' AS DATE) AS anio_descripcion,
        status_iucn,
        familia,
        genero,
        {{ dbt_utils.generate_surrogate_key(['genero']) }} AS genero_id,
        tipo_agua,
        TRY_CAST(SPLIT_PART(tamamio_medio, ' ', 1) AS INT) AS tamanio_medio_cm,
        TRY_CAST(SPLIT_PART(tamanio_maximo, ' ', 1) AS INT) AS tamanio_maximo_cm,
        CASE
            WHEN logevidad = 'no data' THEN 2
            ELSE TRY_CAST(SPLIT_PART(logevidad, ' ', 1) AS INT)
        END AS longevidad_anios,
        forma,
        SPLIT_PART(dieta, ' ', 1) AS dieta,
        sociabilidad,
        CASE
            WHEN territorial = 'Sí' THEN TRUE
            WHEN territorial = 'No' THEN FALSE
            ELSE FALSE
        END AS territorial_bool,
        modo_de_vida,
        reproduccion,
        {{ dbt_utils.generate_surrogate_key(['pais']) }} AS pais_id,
        rios,
        TRY_CAST(SPLIT_PART(temperatura_origen, '-', 1) AS INT) AS temperatura_minima_origen,
        TRY_CAST(SUBSTRING(SPLIT_PART(temperatura_origen, '-', 2), 1 , 2) AS INT) AS temperatura_maxima_origen,
        TRY_CAST(SPLIT_PART(ph_origen, '-', 1) AS INT) AS ph_minimo_origen,
        TRY_CAST(SPLIT_PART(ph_origen, '-', 2) AS INT) AS ph_maximo_origen,
        TRY_CAST(SPLIT_PART(gh_origen, '-', 1) AS INT) AS gh_minimo_origen,
        TRY_CAST(SPLIT_PART(gh_origen, '-', 2) AS INT) AS gh_maximo_origen,
        corriente,
        TRY_CAST(SPLIT_PART(volumen_minimo, ' ', 1) AS INT) AS volumen_minimo_litros,
        TRY_CAST(poblacion_minima AS INT) AS poblacion_minima,
        TRY_CAST(SPLIT_PART(temperatura_acuario, '-', 1) AS INT) AS temperatura_acuario_minimo,
        TRY_CAST(SUBSTRING(SPLIT_PART(temperatura_acuario, '-', 2), 1, 2) AS INT) AS temperatura_acuario_maximo,
        TRY_CAST(SPLIT_PART(ph_acuario, '-', 1) AS INT) AS ph_acuario_minimo,
        TRY_CAST(SPLIT_PART(ph_acuario, '-', 2) AS INT) AS ph_acuario_maximo,
        dificultad,
        robustez,
        comportamiento,
        CASE
            WHEN disponibilidad = 'no data' THEN 'rare'
            ELSE disponibilidad
        END AS disponibilidad
    FROM source
)

SELECT * FROM renamed