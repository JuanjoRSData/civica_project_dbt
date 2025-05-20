{{
  config(
    materialized='table'
  )
}}

with 

source_date as (

    select * from {{ ref('fct_items_venta') }}

),

renamed as (

    select
        date_id as fecha_dia
    from source_date 
    GROUP BY venta_id, date_id

)
select * from renamed
