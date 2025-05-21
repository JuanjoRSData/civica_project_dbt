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

    select * from {{ source('fish_data', 'statuses') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['s.status_uicn_id'])}} AS status_uicn_id,
        {{ dbt_utils.generate_surrogate_key(['f.fish_id'])}} AS status_uicn_id,
        abreviatura_status,        
        status_descripcion
    from source_fish f
    JOIN source_status s
    ON f.status_iucn = s.abreviatura_status

)

select * from renamed

