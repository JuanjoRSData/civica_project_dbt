{{
  config(
    materialized='view'
  )
}}


with 

source as (

    select * from {{ source('fish_data', 'paises') }}

),

renamed as (

    select
        *
    from source

) 

select * from renamed
