{{
  config(
    materialized='view'
  )
}}

with 

source_items as (

    select * from {{ source('fish_data', 'items_venta') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['i.item_ventas_id'])}} AS items_venta_id,
        {{ dbt_utils.generate_surrogate_key(['i.venta_id'])}} AS venta_id,
        {{ dbt_utils.generate_surrogate_key(['i.pez_id'])}} AS fish_id,
        cantidad
    from source_items i
    INNER JOIN {{ ref('stg_fish_data__fish') }} f 
    ON i.pez_id = f.fish_id  
    
)
select * from renamed
