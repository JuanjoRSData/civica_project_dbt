{{
  config(
    materialized='view'
  )
}}

with 

source as (

    select * from {{ source('fish_data', 'precios') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['p.price_id'])}} AS precio_id,
        {{ dbt_utils.generate_surrogate_key(['p.fish_id'])}} AS fish_id,
        p.precio,
        p.fecha
    from source p
    INNER JOIN {{ ref('stg_fish_data__fish') }} f 
      ON p.fish_id = f.fish_id  -- Solo precios con fish_id válido

)

select * from renamed
