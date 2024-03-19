{% macro stg_orders() %}

{% for name, identifier in var('regions').items() %}

{{'WITH' if loop.first }} {{name.split(' ') | join('_') | upper }} AS (

    WITH SOURCE AS (
        SELECT * FROM {{ source('raw_' ~ identifier, 'orders') }}
    ),
    RENAMED AS (
        SELECT
            ID::INT AS ID, 
            DATE::TIMESTAMP AS DATE, 
            CUSTOMER_ID::INT AS CUSTOMER_ID
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