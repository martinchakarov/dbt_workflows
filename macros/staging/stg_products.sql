{% macro stg_products() %}

{% for name, identifier in var('regions').items() %}

{{'WITH' if loop.first }} {{name.split(' ') | join('_') | upper }} AS (

    WITH SOURCE AS (
        SELECT * FROM {{ source('raw_' ~ identifier, 'products') }}
    ),

    RENAMED AS (
        SELECT
            ID::INT AS ID, 
            NAME::STRING AS NAME, 
            PRICE::FLOAT AS PRICE, 
            ON_SALE::STRING AS CURRENTLY_ON_SALE
        FROM SOURCE
    )

    SELECT * FROM RENAMED
  
) {{',' if not loop.last}}
{% endfor %}

{% for name, identifier in var('regions').items() %}
SELECT * FROM {{name.split(' ') | join('_') | upper }}

{{ 'UNION' if not loop.last }}
{% endfor %}

{% endmacro %}