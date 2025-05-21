{{
  config(
    materialized='view'
  )
}}

with 

source_date as (

    select * from {{ ref('stg_fish_data__fechas_dias') }}

),

renamed as (

    select
        *
    from source_date 

)
select * from renamed
