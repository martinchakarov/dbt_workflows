WITH SOURCE AS (
      SELECT * FROM {{ source('raw', 'products') }}
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
  