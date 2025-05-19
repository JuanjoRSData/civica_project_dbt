with 

source as (

    select * from {{ source('fish_data', 'fish') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['fish_id'])}} AS fish_id,
        nombre_cientifico,
        descriptor AS nombre_descriptor,
        CAST(anio_descripcion + '-01-01' AS DATE) AS anio_descripcion,
        status_iucn,
        {{ dbt_utils.generate_surrogate_key(['genero'])}} AS genero_id,
        tipo_agua,
        CAST(SUBSTRING_INDEX(tamamio_medio, ' ', 1), INT)::INT AS tamamio_medio_cm,
        CAST(SUBSTRING_INDEX(tamanio_maximo, ' ', 1), INT)::INT AS tamanio_maximo_cm,
        CASE
            WHEN longevidad IN 'no data' THEN 2::INT
            ELSE CAST(SUBSTRING_INDEX(longevidad, ' ', 1), INT)::INT
        END AS longevidad_anios;
        forma,
        SUBSTRING_INDEX(dieta, ' ', 1) AS dieta,
        sociabilidad,
        CASE
            WHEN territorial IN 'Sí' THEN true,
            WHEN territorial IN 'No' THEN false,
            ELSE false
        END AS territorial_bool;
        modo_de_vida,
        reproduccion,
        {{ dbt_utils.generate_surrogate_key(['pais'])}} AS pais,
        rio,
        CAST(SUBSTRING_INDEX(temperatura, '-', 1), INT)::INT temperatura_minima_origen,
        CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(temperatura, '-', 2), 'º', 1), INT)::INT temperatura_maxima_origen,
        CAST(SUBSTRING_INDEX(ph, '-', 1), INT)::INT ph_minimo_origen,
        CAST(SUBSTRING_INDEX(ph, '-', 2), INT)::INT ph_maximo_origen,
        CAST(SUBSTRING_INDEX(gh, '-', 1), INT)::INT gh_minimo_origen,
        CAST(SUBSTRING_INDEX(gh, '-', 2), INT)::INT gh_maximo_origen,
        corriente,
        volumen_minimo_litros,
        CAST(SUBSTRING_INDEX(volumen_minimo, ' ', 1), INT)::INT volumen_minimo_litros,
        poblacion_minima::INT,
        CAST(SUBSTRING_INDEX(temperatura_acuario, '-', 1), INT)::INT temperatura_acuario_minimo,
        CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(temperatura_acuario, '-', 2), 'º', 1), INT), INT)::INT temperatura_acuario_maximo,
        ph_acuario,
        CAST(SUBSTRING_INDEX(ph_acuario, '-', 1), INT)::INT ph_acuario_minimo_origen,
        CAST(SUBSTRING_INDEX(ph_acuario, '-', 2), INT)::INT ph_acuario_maximo_origen,
        dificultad,
        robustez,
        comportamiento,
        CASE
            WHEN disponibilidad IN 'no data' THEN 'rare',
            
            ELSE disponibilidad
        END AS disponibilidad;
    from source

)

select * from renamed
