{{
    config(
        unique_key='listing_id',
        materialized='table'
    )
}}

with check_dimensions as
(select 
	listing_id,
    SCRAPED_DATE,
    case when LISTING_NEIGHBOURHOOD in (select LISTING_NEIGHBOURHOOD from {{ ref('stg_Host') }}) then LISTING_NEIGHBOURHOOD else 'unknown' end as LISTING_NEIGHBOURHOOD,
	case when host_id in (select distinct host_id from {{ ref('stg_Host') }}) then host_id else 0 end as host_id,
    case when HOST_NAME in (select HOST_NAME from {{ ref('stg_Host') }}) then HOST_NAME else 'unknown' end as HOST_NAME,
    case when HOST_SINCE in (select HOST_SINCE from {{ ref('stg_Host') }}) then HOST_SINCE else '1900-01-01' end as HOST_SINCE,
    case when HOST_IS_SUPERHOST in (select HOST_IS_SUPERHOST from {{ ref('stg_Host') }}) then HOST_IS_SUPERHOST else 'false' end as HOST_IS_SUPERHOST,
    case when HOST_NEIGHBOURHOOD in (select HOST_NEIGHBOURHOOD from {{ ref('stg_Host') }}) then HOST_NEIGHBOURHOOD else 'unknown' end as HOST_NEIGHBOURHOOD,
	case when PROPERTY_TYPE in (select PROPERTY_TYPE from {{ ref('stg_Property') }}) then PROPERTY_TYPE else 'unknown' end as PROPERTY_TYPE,
	case when ROOM_TYPE in (select ROOM_TYPE from {{ ref('stg_room') }}) then ROOM_TYPE else 'unknown' end as ROOM_TYPE,
	case when price in (select price from {{ ref('stg_Property') }}) then price else 0 end as price,
    case when ACCOMMODATES in (select ACCOMMODATES from {{ ref('stg_Property') }}) then ACCOMMODATES else 0 end as ACCOMMODATES,
    case when HAS_AVAILABILITY in (select HAS_AVAILABILITY from {{ ref('stg_Property') }}) then HAS_AVAILABILITY else 'false' end as HAS_AVAILABILITY,
    case when AVAILABILITY_30 in (select AVAILABILITY_30 from {{ ref('stg_Property') }}) then AVAILABILITY_30 else 0 end as AVAILABILITY_30,
    case when NUMBER_OF_REVIEWS in (select NUMBER_OF_REVIEWS from {{ ref('stg_room') }}) then NUMBER_OF_REVIEWS else 0 end as NUMBER_OF_REVIEWS,
    case when REVIEW_SCORES_RATING in (select REVIEW_SCORES_RATING from {{ ref('stg_room') }}) then REVIEW_SCORES_RATING else 0 end as REVIEW_SCORES_RATING
from {{ ref('stg_listing') }})

select 
	a.listing_id, 
	a.SCRAPED_DATE as date,
    a.LISTING_NEIGHBOURHOOD,
    b.lga_code as LISTING_NEIGHBOURHOOD_LGA_CODE,
    a.host_id,
    a.HOST_NAME,
    a.HOST_SINCE,
    a.HOST_IS_SUPERHOST,
    a.HOST_NEIGHBOURHOOD,
    c.lga_code as HOST_NEIGHBOURHOOD_LGA_CODE,
    case when a.HOST_NEIGHBOURHOOD in (select suburb_name from {{ ref('stg_Suburb') }}) then a.LISTING_NEIGHBOURHOOD 
    else c.lga_name 
    end as HOST_NEIGHBOURHOOD_LGA_NAME,
    a.PROPERTY_TYPE,
    a.ROOM_TYPE,
    a.price,
    a.ACCOMMODATES,
    a.HAS_AVAILABILITY,
    a.AVAILABILITY_30,
    a.NUMBER_OF_REVIEWS,
    a.REVIEW_SCORES_RATING
from check_dimensions a 
left join {{ ref('stg_LGA') }} b  on a.LISTING_NEIGHBOURHOOD = b.lga_name 
left join {{ ref('stg_LGA') }} c  on a.HOST_NEIGHBOURHOOD = c.lga_name
left join {{ ref('stg_Suburb') }} d  on a.HOST_NEIGHBOURHOOD = d.lga_name