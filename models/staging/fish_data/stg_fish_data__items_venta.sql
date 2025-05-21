{{
    config(
        materialized='incremental',
        on_schema_change='append_new_columns'
    )
}}

with 

source_items as (

    select * from {{ source('fish_data', 'items_venta') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['item_ventas_id'])}} AS items_venta_id,
        {{ dbt_utils.generate_surrogate_key(['venta_id'])}} AS venta_id,
        {{ dbt_utils.generate_surrogate_key(['pez_id'])}} AS fish_id,
        cantidad,
        CAST(CURRENT_TIMESTAMP AS TIMESTAMP_TZ) AS upload_date
    from source_items 
   
    {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        -- (uses >= to include records arriving later on the same day as the last run of this model)
        where upload_date >= (select coalesce(max(upload_date), '1900-01-01') from {{ this }})

    {% endif %}
    
)
select * from renamed




