{{
    config(
        materialized='view'
    )
}}

SELECT 
listing_neighbourhood,
PROPERTY_TYPE,
ROOM_TYPE,
ACCOMMODATES,
CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date)) AS month_year,
COUNT(CASE WHEN has_availability = 't' THEN 1 END) AS active_listings,
(COUNT(CASE WHEN has_availability = 't' THEN 1 END) / COUNT(listing_id)) * 100 AS active_listings_rate,
MIN(CASE WHEN has_availability = 't' THEN price END) AS min_price_active_listings,
MAX(CASE WHEN has_availability = 't' THEN price END) AS max_price_active_listings,
PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CASE WHEN has_availability = 't' THEN price END) AS median_price_active_listings,
AVG(CASE WHEN has_availability = 't' THEN price END) AS avg_price_active_listings,
COUNT(DISTINCT host_id) AS distinct_hosts_count,
(COUNT(CASE WHEN host_is_superhost = 't' THEN 1 END) / COUNT(DISTINCT host_id)) * 100 AS superhost_rate,
AVG(CASE WHEN has_availability = 't' THEN review_scores_rating END) AS avg_review_scores_active_listings,
((COUNT(CASE WHEN has_availability = 't' THEN 1 END) - LAG(COUNT(CASE WHEN has_availability = 't' THEN 1 END)) OVER (PARTITION BY property_type, room_type, accommodates ORDER BY CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date)))) / NULLIF(LAG(COUNT(CASE WHEN has_availability = 't' THEN 1 END)) OVER (PARTITION BY property_type, room_type, accommodates ORDER BY CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date))), 0)) * 100 AS percentage_change_active_listings,
((COUNT(CASE WHEN has_availability = 'f' THEN 1 END) - LAG(COUNT(CASE WHEN has_availability = 'f' THEN 1 END)) OVER (PARTITION BY property_type, room_type, accommodates ORDER BY CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date)))) / NULLIF(LAG(COUNT(CASE WHEN has_availability = 'f' THEN 1 END)) OVER (PARTITION BY property_type, room_type, accommodates ORDER BY CONCAT(EXTRACT(MONTH FROM date), '/', EXTRACT(YEAR FROM date))), 0)) * 100 AS percentage_change_inactive_listings,
SUM(CASE WHEN has_availability = 't' THEN (30 - availability_30) END) AS total_number_of_stays,
SUM(CASE WHEN has_availability = 't' THEN price * (30 - availability_30) END) / COUNT(CASE WHEN has_availability = 't' THEN 1 END) AS avg_estimated_revenue_per_active_listing
FROM {{ ref('facts_listings') }}
GROUP BY listing_neighbourhood, property_type, room_type, accommodates, month_year
ORDER BY property_type, room_type, accommodates, month_year