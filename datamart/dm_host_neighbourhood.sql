{{
    config(
        materialized='view'
    )
}}

SELECT
HOST_NEIGHBOURHOOD_LGA_NAME,
CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date)) AS month_year,
COUNT(DISTINCT host_id) AS distinct_host_count,
SUM((30 - availability_30) * price) as estimated_revenue,
SUM((30 - availability_30) * price) / COUNT(DISTINCT host_id) AS estimated_revenue_per_host
FROM {{ ref('facts_listings') }}
GROUP BY HOST_NEIGHBOURHOOD_LGA_NAME, month_year
ORDER BY HOST_NEIGHBOURHOOD_LGA_NAME, month_year