{{
    config(
        unique_key='host_id',
        materialized='view'
    )
}}

with

source as (

    select * from {{ ref('room_snapshot') }}

),

renamed as (
    select
    HOST_ID,
    ROOM_TYPE,
    NUMBER_OF_REVIEWS,
    CASE WHEN REVIEW_SCORES_RATING = 'NaN' THEN 0 ELSE REVIEW_SCORES_RATING END AS REVIEW_SCORES_RATING, 
    CASE WHEN REVIEW_SCORES_ACCURACY = 'NaN' THEN 0 ELSE REVIEW_SCORES_ACCURACY END AS REVIEW_SCORES_ACCURACY, 
    CASE WHEN REVIEW_SCORES_CLEANLINESS = 'NaN' THEN 0 ELSE REVIEW_SCORES_CLEANLINESS END AS REVIEW_SCORES_CLEANLINESS, 
    CASE WHEN REVIEW_SCORES_CHECKIN = 'NaN' THEN 0 ELSE REVIEW_SCORES_CHECKIN END AS REVIEW_SCORES_CHECKIN, 
    CASE WHEN REVIEW_SCORES_COMMUNICATION = 'NaN' THEN 0 ELSE REVIEW_SCORES_COMMUNICATION END AS REVIEW_SCORES_COMMUNICATION, 
    CASE WHEN REVIEW_SCORES_VALUE = 'NaN' THEN 0 ELSE REVIEW_SCORES_VALUE END AS REVIEW_SCORES_VALUE,
    SCRAPED_DATE::date as SCRAPED_DATE,
    CURRENT_TIMESTAMP::timestamp as ingestion_datetime, 
    dbt_valid_from ::timestamp,
    dbt_valid_to::timestamp
    from source
),

unknown as (
    select 
        0 as HOST_ID,
        'unknown' as PROPERTY_TYPE,
        0 as NUMBER_OF_REVIEWS,
        0 as REVIEW_SCORES_RATING,
        0 AS REVIEW_SCORES_ACCURACY,
        0 as REVIEW_SCORES_CLEANLINESS,
        0 as REVIEW_SCORES_CHECKIN,
        0 as REVIEW_SCORES_COMMUNICATION,
        0 as REVIEW_SCORES_VALUE,
        '1900-01-01'::date AS SCRAPED_DATE,
        null::timestamp AS ingestion_datetime,
        '1900-01-01'::timestamp as dbt_valid_from,
        null::timestamp as dbt_valid_to
)

select * from unknown
union all 
select * from renamed