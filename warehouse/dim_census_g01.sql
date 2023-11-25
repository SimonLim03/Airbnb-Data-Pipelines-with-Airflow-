{{
    config(
        unique_key='lga_code',
        materialized='table'
    )
}}

select * from {{ ref('stg_G01') }}