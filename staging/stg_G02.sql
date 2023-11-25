{{
    config(
        unique_key='lga_code',
        materialized='view'
    )
}}

with

source  as (

    select * from {{source('raw','g02')}}

),

renamed as (
    SELECT
    CASE 
    WHEN lga_code_2016 LIKE 'LGA%' THEN SUBSTRING(lga_code_2016, 4) :: INT ELSE lga_code_2016 :: INT END AS lga_code,
    median_age_persons,
    median_mortgage_repay_monthly, 
    median_tot_prsnl_inc_weekly, 
    median_rent_weekly, 
    median_tot_fam_inc_weekly, 
    average_num_psns_per_bedroom, 
    median_tot_hhd_inc_weekly, 
    average_household_size
    FROM source
)

select * from renamed