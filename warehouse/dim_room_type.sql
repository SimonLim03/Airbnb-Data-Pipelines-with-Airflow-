{{
    config(
        unique_key='host_id',
        materialized='table'
    )
}}

select * from {{ ref('stg_room') }}