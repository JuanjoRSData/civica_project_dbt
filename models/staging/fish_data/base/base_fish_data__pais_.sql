{{
  config(
    materialized='view'
  )
}}

WITH

source as (

    select * from {{ source('fish_data', 'paises') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['nombre'])}} AS pais_id,
        nombre,
        name AS nombre_ingles,
        nom AS nombre_frances,
        iso2,
        iso3,
        phone_code,
        continente

    from source

)

select * from renamed