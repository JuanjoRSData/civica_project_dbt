{{
  config(
    materialized='view'
  )
}}

with 

source_fish as (

    select * from {{ ref('base_fish_data__fish') }}

),

source_status as (

    select * from {{ ref('base_fish_data__statuses') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['f.fish_id'])}} AS status_fish_id,
        abreviatura_status,        
        status_descripcion
    from source_fish f
    JOIN source_status s
    ON f.status_iucn = s.abreviatura_status

)

select * from renamed

