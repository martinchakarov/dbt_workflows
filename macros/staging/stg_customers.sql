{% macro stg_customers() %}

{% for name, identifier in var('regions').items() %}

{{'WITH' if loop.first }} {{name.split(' ') | join('_') | upper }} AS (

    WITH SOURCE AS (
            SELECT * FROM {{ source('raw_' ~ identifier, 'customers') }}
        ),

        FINAL AS (
            SELECT
                ID::INT AS ID,
                FIRST_NAME::STRING AS FIRST_NAME,
                LAST_NAME::STRING AS LAST_NAME,
                EMAIL::STRING AS EMAIL,
                GENDER::STRING AS GENDER,
                IP_ADDRESS::STRING AS IP_ADDRESS,
                REGION::STRING AS REGION
            FROM SOURCE
        )

        SELECT 
            * 
        FROM FINAL
        WHERE REGION = '{{name}}'

) {{',' if not loop.last}}
{% endfor %}

{% for name, identifier in var('regions').items() %}
SELECT * FROM {{name.split(' ') | join('_') | upper }}

{{ 'UNION ALL' if not loop.last }}
{% endfor %}

{% endmacro %}