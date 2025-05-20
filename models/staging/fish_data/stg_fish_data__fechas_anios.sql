{{
  config(
    materialized = 'view',
    )
}}

WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="year",
        start_date="to_date('01/01/1757', 'mm/dd/yyyy')",
        end_date="dateadd(year, 10, cast(current_timestamp as date))"
    )
    }}
),
renamed_casted AS (
    select
        date_year as fecha_anio_id,
        date_year as fecha,
        year(date_year) as anio,
    from date_spine
)
SELECT * FROM renamed_casted