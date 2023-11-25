{{
    config(
        unique_key='host_id',
        materialized='view'
    )
}}

with

source as (

    select * from {{ ref('property_snapshot') }}

),

renamed as (
    select
    HOST_ID,
    PROPERTY_TYPE, 
    ACCOMMODATES, 
    PRICE::FLOAT as PRICE, 
    HAS_AVAILABILITY::boolean, 
    AVAILABILITY_30, 
    NUMBER_OF_REVIEWS,
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
        0 as ACCOMMODATES,
        0 as PRICE,
        'false'::boolean as HAS_AVAILABILITY,
        0 as AVAILABILITY_30,
        0 as NUMBER_OF_REVIEWS,
        '1900-01-01'::date AS SCRAPED_DATE,
        null::timestamp AS ingestion_datetime,
        '1900-01-01'::timestamp as dbt_valid_from,
        null::timestamp as dbt_valid_to
)
select * from unknown
union all 
select * from renamed