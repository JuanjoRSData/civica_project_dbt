
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

source_fish as (

    select * from {{ ref('dim_fish') }}

),

renamed as (

    WITH ranking_meses AS (
    SELECT 
        TO_CHAR(DATE_ID, 'YYYY-MM') AS mes,
        i.FISH_ID,
        nombre_cientifico,
        SUM(CANTIDAD) AS unidades,
        SUM(CANTIDAD * precio_unidad) AS importe,
        RANK() OVER (PARTITION BY TO_CHAR(DATE_ID, 'YYYY-MM') 
                     ORDER BY SUM(CANTIDAD) DESC) AS rank_mas_vendidos,
        RANK() OVER (PARTITION BY TO_CHAR(DATE_ID, 'YYYY-MM') 
                     ORDER BY SUM(CANTIDAD) ASC) AS rank_menos_vendidos
    FROM 
        source_items_ventas i
    JOIN 
        source_fish f 
    ON i.FISH_ID = f.FISH_ID
    WHERE 
        precio_unidad IS NOT NULL
    GROUP BY 
        TO_CHAR(DATE_ID, 'YYYY-MM'),
        i.FISH_ID,
        nombre_cientifico
    )
    SELECT 
        mes,
        'TOP ' || ranking AS posicion,
        FISH_ID,
        nombre_cientifico,
        unidades,
        importe
    FROM (
        -- Top 3 más vendidos
        SELECT 
            mes,
            rank_mas_vendidos AS ranking,
            FISH_ID,
            nombre_cientifico,
            unidades,
            importe,
            'MÁS' AS tipo
        FROM 
            ranking_meses
        WHERE 
            rank_mas_vendidos <= 3
        
        UNION ALL
        
        -- Top 3 menos vendidos (excluyendo no vendidos)
        SELECT 
            mes,
            rank_menos_vendidos AS ranking,
            FISH_ID,
            nombre_cientifico,
            unidades,
            importe,
            'MENOS' AS tipo
        FROM 
            ranking_meses
        WHERE 
            rank_menos_vendidos <= 3
            AND unidades > 0
    )
    ORDER BY 
        mes,
        tipo DESC,
        ranking

)
select * from renamed











