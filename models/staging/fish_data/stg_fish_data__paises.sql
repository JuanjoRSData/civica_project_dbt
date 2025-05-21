{{
  config(
    materialized='view'
  )
}}


with 

source as (

    select * from {{ ref('base_fish_data__paises') }}

),

renamed as (

    select
        *
    from source

) 

select * from renamed
