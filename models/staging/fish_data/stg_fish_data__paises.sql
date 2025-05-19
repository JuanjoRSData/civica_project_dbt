{{
  config(
    materialized='view'
  )
}}


with 

source as (

    select * from {{ ref('base_fish_data_pais_') }}

),

renamed as (

    select
        *
    from source

) 

select * from renamed
