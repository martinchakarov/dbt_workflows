{% macro stg_order_items() %}

{% for name, identifier in var('regions').items() %}

{{'WITH' if loop.first }} {{name.split(' ') | join('_') | upper }} AS (

    WITH SOURCE AS (
        SELECT * FROM {{ source('raw_' ~ identifier, 'order_items') }}
    ),

    RENAMED AS (
        SELECT
            ORDER_ID::INT AS ORDER_ID, 
            PRODUCT_ID::INT AS PRODUCT_ID, 
            QUANTITY::INT AS QUANTITY
        FROM SOURCE
    )

    SELECT * FROM RENAMED
  
) {{',' if not loop.last}}
{% endfor %}

{% for name, identifier in var('regions').items() %}
SELECT * FROM {{name.split(' ') | join('_') | upper }}

{{ 'UNION ALL' if not loop.last }}
{% endfor %}

{% endmacro %}