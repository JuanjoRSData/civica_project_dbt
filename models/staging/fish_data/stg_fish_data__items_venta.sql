{{
  config(
    materialized='view'
  )
}}

with 

source_fish as (

    select * from {{ source('fish_data', 'items_venta') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['item_ventas_id'])}} AS items_venta_id,
        {{ dbt_utils.generate_surrogate_key(['venta_id'])}} AS venta_id,
        {{ dbt_utils.generate_surrogate_key(['pez_id'])}} AS fish_id,
        cantidad
    from source_fish 

)
select * from renamed
