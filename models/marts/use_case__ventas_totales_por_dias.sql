
{{
  config(
    materialized='table'
  )
}}

with 

source_items_ventas as (

    select * from {{ ref('fct_items_venta') }}

),

source_date as (

    select * from {{ ref('dim_fecha') }}

),

renamed as (

    SELECT 
        i.DATE_ID AS fecha,
        f.nombre_dia AS dia_semana,
        SUM(CANTIDAD) AS unidades_vendidas,
        SUM(CANTIDAD * i.precio_unidad) AS importe_total,
        COUNT(DISTINCT VENTA_ID) AS cantidad_transacciones,
        ROUND(SUM(CANTIDAD * precio_unidad) / NULLIF(COUNT(DISTINCT VENTA_ID), 0), 2) AS ticket_promedio
    FROM 
        source_items_ventas i
    JOIN source_date f
    ON i.date_id = f.date_id
    WHERE 
        i.precio_unidad IS NOT NULL
    GROUP BY 
        i.DATE_ID,
        f.nombre_dia
    ORDER BY 
        fecha DESC

)
select * from renamed
















