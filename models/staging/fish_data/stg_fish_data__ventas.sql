with 

source as (

    select * from {{ source('fish_data', 'ventas') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['venta_id'])}} AS venta_id,
        fecha_venta

    from source

)

select * from renamed
