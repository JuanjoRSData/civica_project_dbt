with 

call_statuses as (

    select * from {{ source('fish_data', 'statuses') }}

),
call_fish as (

    select * from {{ source('fish_data', 'fish') }}

),

renamed as (

    select
        {{ dbt_utils.generate_surrogate_key(['a.abreviatura_status'])}} AS status_iucn_id,
        {{ dbt_utils.generate_surrogate_key(['b.fish_id'])}} AS status_iucn_id,
        CAST(CURRENT_TIMESTAMP AS timestamp_tz)AS creation_date
    from call_statuses a
    join call_fish b
    on a.abreviatura_status = b.status_iucn
)

select * from renamed
