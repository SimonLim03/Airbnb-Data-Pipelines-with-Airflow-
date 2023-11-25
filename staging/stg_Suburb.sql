{{
    config(
        unique_key='lga_name',
        materialized='view'
    )
}}

with

source  as (

    select * from {{source('raw','nsw_suburb')}}

),

renamed as (
    select
        CONCAT(UPPER(SUBSTRING(lga_name, 1, 1)), LOWER(SUBSTRING(lga_name, 2))) AS lga_name,
        CONCAT(UPPER(SUBSTRING(suburb_name, 1, 1)), LOWER(SUBSTRING(suburb_name, 2))) AS suburb_name
    from source 
)

select * from renamed