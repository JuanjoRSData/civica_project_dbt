{{
  config(
    materialized='view'
  )
}}

with 

source_fish as (

    select * from {{ ref('base_fish_data__fish') }}

),

renamed as (

    select
        *
    from source_fish 

)
select * from renamed
