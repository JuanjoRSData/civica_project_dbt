with 

source as (

    select * from {{ source('fish_data', 'fish') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['genero'])}} AS genero_id,
        familia,
        
    from source

)

select * from renamed
