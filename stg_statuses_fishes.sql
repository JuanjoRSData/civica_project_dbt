{{
  config(
    materialized='view'
  )
}}


with 

source as (

    select * from {{ source('fish_data', 'statuses') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['abreviatura_status'])}} AS status_iucn_id,
        abreviatura_status,        
        status_descripcion
    from source

) 

select * from renamed
