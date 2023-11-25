{{
    config(
        unique_key='HOST_ID',
        materialized='view'
    )
}}

with

source  as (

    select * from {{ ref('host_snapshot') }}

),

renamed as (
    select
    HOST_ID, 
    CASE 
    WHEN HOST_NAME = 'Na' THEN 'unknown' 
    WHEN HOST_NAME = 'NaN' Then 'unknown' 
    ELSE HOST_NAME
    END AS HOST_NAME, 
    CASE WHEN HOST_SINCE = 'NaN' THEN '1900-01-01'::date ELSE to_date(HOST_SINCE, 'DD/MM/YYYY') END AS HOST_SINCE, 
    CASE WHEN HOST_IS_SUPERHOST = 'NaN' THEN 'false'::boolean ELSE HOST_IS_SUPERHOST::boolean END AS HOST_IS_SUPERHOST, 
    CASE WHEN HOST_NEIGHBOURHOOD = 'NaN' THEN 'unknown' ELSE HOST_NEIGHBOURHOOD END AS HOST_NEIGHBOURHOOD,
    LISTING_NEIGHBOURHOOD,
    SCRAPED_DATE::date as SCRAPED_DATE,
    CURRENT_TIMESTAMP::timestamp as ingestion_datetime,
    dbt_valid_from::timestamp,
    dbt_valid_to::timestamp
    from source
),

unknown as (
    select 
        0 as HOST_ID,
        'unknown' as HOST_NAME,
        '1900-01-01'::date AS HOST_SINCE,
        'false'::boolean as HOST_IS_SUPERHOST,
        'unknown' as HOST_NEIGHBOURHOOD,
        'unknown' as LISTING_NEIGHBOURHOOD,
        '1900-01-01'::date AS SCRAPED_DATE,
        null::timestamp AS ingestion_datetime,
        '1900-01-01'::timestamp as dbt_valid_from,
        null::timestamp as dbt_valid_to

)
select * from unknown
union all 
select * from renamed
