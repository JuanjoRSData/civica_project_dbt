with 

source as (

    select * from {{ source('fish_data', 'precios') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['price_id'])}} AS precio_id,
        {{ dbt_utils.generate_surrogate_key(['fish_id'])}} AS fish_id ,
        precio,
        fecha

    from source

)

select * from renamed
