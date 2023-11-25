-- part 3: Ad-hoc Analysis

--a. Best performing listing_neighbourhood and worst performin listing_neighbourhood based on estimated revenue per active listings (from a population point of view)
WITH aggregated_data AS (
    SELECT 
    listing_neighbourhood,
    avg_estimated_revenue_per_active_listing
    FROM raw.dm_listing_neighbourhood dln 
    GROUP BY listing_neighbourhood, avg_estimated_revenue_per_active_listing
),
best_worst_performing_neighborhood AS (
    SELECT 
    listing_neighbourhood,
    AVG(avg_estimated_revenue_per_active_listing) AS avg_revenue
    FROM aggregated_data
    GROUP BY listing_neighbourhood
    ORDER BY avg_revenue DESC
),
-- this table is used to obtain median age for each listing_neighbourhood
age_population as (   
    select 
    a.lga_code,
    a.lga_name,
    b.median_age_persons
    from warehouse.dim_lga a
    left join warehouse.dim_census_g02 b on a.lga_code = b.lga_code
)
SELECT 
a.listing_neighbourhood as listing_neighbourhood,
a.avg_revenue as avg_revenue,
b.median_age_persons
FROM best_worst_performing_neighborhood a
left join age_population b on a.listing_neighbourhood = b.lga_name
order by avg_revenue desc;


-- b. The best type of listing (property type, room type and accommodates) for for the top 5 “listing_neighbourhood”
WITH top5_neighborhoods AS (
    SELECT 
        listing_neighbourhood,
        AVG(avg_estimated_revenue_per_active_listing) avg_estimated_revenue_per_active_listing
    FROM raw.dm_listing_neighbourhood
    GROUP BY listing_neighbourhood
    ORDER BY avg_estimated_revenue_per_active_listing DESC
    LIMIT 5
)
select
listing_neighbourhood,
property_type,
room_type,
accommodates,
total_number_of_stays
FROM raw.dm_property_type dpt 
WHERE listing_neighbourhood IN (SELECT listing_neighbourhood FROM top5_neighborhoods)
GROUP BY listing_neighbourhood, property_type, room_type, accommodates, total_number_of_stays 
ORDER BY total_number_of_stays desc
limit 5; 

-- c. Do hosts with multiple listings are more inclined to have their listings in the same LGA as where they live?
SELECT 
a.HOST_NEIGHBOURHOOD_LGA_NAME,
b.host_id,
COUNT(DISTINCT b.listing_id) AS num_listings
FROM raw.dm_host_neighbourhood a
LEFT JOIN warehouse.facts_listings b ON a.host_neighbourhood_lga_name = b.host_neighbourhood_lga_name
GROUP BY a.HOST_NEIGHBOURHOOD_LGA_NAME, b.host_id
HAVING COUNT(DISTINCT b.listing_id) > 5;


-- d. Can hosts cover their the annualised median mortgage repayment of their listing’s listing_neighbourhood by estimated revenue over the last 12 months can cover?
WITH Hosts_Listings_Revenue AS (
    SELECT 
    distinct b.host_id,
    EXTRACT(YEAR FROM b.date) as year,
    a.host_neighbourhood_lga_name,
    a.estimated_revenue_per_host 
    FROM raw.dm_host_neighbourhood a
    left join warehouse.facts_listings b on a.host_neighbourhood_lga_name = b.host_neighbourhood_lga_name
    GROUP BY distinct b.host_id,EXTRACT(YEAR FROM b.date), a.host_neighbourhood_lga_name, a.estimated_revenue_per_host
    HAVING COUNT(DISTINCT b.listing_id) = 1
),
Neighborhood_Mortgage AS (
    select
    a.lga_name,
    a.lga_code,
    b.median_mortgage_repay_monthly
    from warehouse.dim_lga a
    left join warehouse.dim_census_g02 b on a.lga_code = b.lga_code
)
SELECT 
    c.host_id,
    c.year,
    c.host_neighbourhood_lga_name,
    SUM(c.estimated_revenue_per_host) AS total_estimated_revenue,
    SUM(d.median_mortgage_repay_monthly) AS total_median_mortgage_repay_monthly,
    CASE 
        WHEN SUM(c.estimated_revenue_per_host) >= SUM(d.median_mortgage_repay_monthly) THEN 'Yes'
        ELSE 'No'
    END AS can_cover_mortgage
FROM Hosts_Listings_Revenue c
LEFT JOIN Neighborhood_Mortgage d ON c.host_neighbourhood_lga_name = d.lga_name
GROUP BY c.host_id, c.year, c.host_neighbourhood_lga_name;
