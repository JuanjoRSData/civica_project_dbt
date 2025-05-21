
with 

source_items_ventas as (

    select * from {{ ref('stg_fish_data__items_venta') }}

),

source_ventas as (

    select * from {{ ref('stg_fish_data__ventas') }}

),

source_precios as (

    select * from {{ ref('stg_fish_data__precios') }}

),

renamed as (

    select
       i.*,
       v.fecha_venta as date_id,
       p.precio as precio_unidad
    from source_items_ventas i
    left join source_ventas v
    on i.venta_id = v.venta_id
    left join source_precios p
    on p.fish_id = i.fish_id

)
select * from renamed
