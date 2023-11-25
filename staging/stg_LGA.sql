{{
    config(
        unique_key='lga_code',
        materialized='view'
    )
}}

with

source  as (

    select * from {{source('raw','nsw_lga')}}

),

renamed as (
    select
        lga_code,
        lga_name
    from source
)

select * from renamed
