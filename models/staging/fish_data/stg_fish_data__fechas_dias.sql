{{
  config(
    materialized = 'view',
    )
}}

WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="to_date('01/01/2000', 'mm/dd/yyyy')",
        end_date="dateadd(year, 10, cast(current_timestamp as date))"
    )
    }}
),
renamed_casted AS (
    select
        date_day as date_id,
        date_day as fecha,
        day(date_day) as dia,
        month(date_day) as mes,
        year(date_day) as anio,
        dayofweek(date_day) as dia_semana_numero,
        dayname(date_day) as nombre_dia,
        weekofyear(date_day) as semana_del_anio,
        monthname(date_day) as nombre_mes,
        quarter(date_day) as trimestre,
        case 
            when dayofweek(date_day) in (0, 6) then 'Fin de semana'  -- Snowflake: 0=Domingo, 6=Sábado
            else 'Día laboral'
        end as tipo_dia,
        row_number() over (partition by year(date_day), quarter(date_day) order by date_day) as dia_trimestre
    from date_spine
)
SELECT * FROM renamed_casted