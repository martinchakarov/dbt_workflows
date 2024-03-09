WITH SOURCE AS (
      SELECT * FROM {{ source('raw', 'orders') }}
),
RENAMED AS (
    SELECT
        ID::INT AS ID, 
        DATE::TIMESTAMP AS DATE, 
        CUSTOMER_ID::INT AS CUSTOMER_ID
    FROM SOURCE
)
SELECT * FROM RENAMED
  