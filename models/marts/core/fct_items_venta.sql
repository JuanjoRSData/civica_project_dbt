
with 

source_items_ventas as (

    select * from {{ ref('stg_fish_data__items_venta') }}

),

renamed as (

    select
       i.*,
       v.fecha_venta as date_id
    from source_items_ventas i
    join {{ ref('stg_fish_data__ventas')}} v
    on i.venta_id = v.venta_id

)
select * from renamed
