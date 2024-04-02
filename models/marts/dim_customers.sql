WITH BASE_DATA AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

FINAL AS (
    SELECT
        ID AS CUSTOMER_ID,
        FIRST_NAME || ' ' || LAST_NAME AS NAME,
        EMAIL,
        CASE WHEN GENDER NOT IN ('Male', 'Female') THEN 'Other' ELSE GENDER END AS GENDER,
        IP_ADDRESS,
        1 as test
    FROM {{ ref('stg_customers') }}
)

SELECT * FROM FINAL