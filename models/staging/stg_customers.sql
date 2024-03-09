WITH SOURCE AS (
      SELECT * FROM {{ source('raw', 'customers') }}
),

FINAL AS (
    SELECT
        ID::INT AS ID,
        FIRST_NAME::STRING AS FIRST_NAME,
        LAST_NAME::STRING AS LAST_NAME,
        EMAIL::STRING AS EMAIL,
        GENDER::STRING AS GENDER,
        IP_ADDRESS::STRING AS IP_ADDRESS
    FROM SOURCE
)

SELECT * FROM FINAL
