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
        f.nombre_dia,
        SUM(i.CANTIDAD * i.PRECIO_UNIDAD) AS importe_total,
        RANK() OVER (ORDER BY SUM(i.CANTIDAD * i.PRECIO_UNIDAD) DESC) AS ranking
    FROM 
        source_items_ventas i
    JOIN source_date f
    ON i.date_id = f.date_id
    WHERE 
        i.PRECIO_UNIDAD IS NOT NULL
    GROUP BY 
        f.nombre_dia,
        EXTRACT(DOW FROM i.DATE_ID)
    ORDER BY 
        importe_total DESC

)
select * from renamed
