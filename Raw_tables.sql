CREATE SCHEMA RAW;

CREATE TABLE raw.listings(
    LISTING_ID INT primary key,
    SCRAPE_ID BIGINT,
    SCRAPED_DATE VARCHAR NULL,
    HOST_ID INT,
    HOST_NAME VARCHAR NULL,
    HOST_SINCE VARCHAR NULL,
    HOST_IS_SUPERHOST VARCHAR NULL,
    HOST_NEIGHBOURHOOD VARCHAR NULL,
    LISTING_NEIGHBOURHOOD VARCHAR NULL,
    PROPERTY_TYPE VARCHAR NULL,
    ROOM_TYPE VARCHAR NULL,
    ACCOMMODATES INT,
    PRICE VARCHAR NULL,
    HAS_AVAILABILITY VARCHAR NULL,
    AVAILABILITY_30 INT,
    NUMBER_OF_REVIEWS INT,
    REVIEW_SCORES_RATING FLOAT,
    REVIEW_SCORES_ACCURACY FLOAT,
    REVIEW_SCORES_CLEANLINESS FLOAT,
    REVIEW_SCORES_CHECKIN FLOAT,
    REVIEW_SCORES_COMMUNICATION FLOAT,
    REVIEW_SCORES_VALUE FLOAT
);

CREATE TABLE raw.nsw_lga(
    lga_code int primary key,
    lga_name varchar null
);

CREATE TABLE raw.nsw_suburb(
    lga_name varchar null primary key,
    suburb_name varchar null
);

CREATE TABLE raw.g01 (
    lga_code_2016 varchar null primary key,
    tot_p_m INT,
    tot_p_f INT,
    tot_p_p INT,
    age_0_4_yr_m INT,
    age_0_4_yr_f INT,
    age_0_4_yr_p INT,
    age_5_14_yr_m INT,
    age_5_14_yr_f INT,
    age_5_14_yr_p INT,
    age_15_19_yr_m INT,
    age_15_19_yr_f INT,
    age_15_19_yr_p INT,
    age_20_24_yr_m INT,
    age_20_24_yr_f INT,
    age_20_24_yr_p INT,
    age_25_34_yr_m INT,
    age_25_34_yr_f INT,
    age_25_34_yr_p INT,
    age_35_44_yr_m INT,
    age_35_44_yr_f INT,
    age_35_44_yr_p INT,
    age_45_54_yr_m INT,
    age_45_54_yr_f INT,
    age_45_54_yr_p INT,
    age_55_64_yr_m INT,
    age_55_64_yr_f INT,
    age_55_64_yr_p INT,
    age_65_74_yr_m INT,
    age_65_74_yr_f INT,
    age_65_74_yr_p INT,
    age_75_84_yr_m INT,
    age_75_84_yr_f INT,
    age_75_84_yr_p INT,
    age_85ov_m INT,
    age_85ov_f INT,
    age_85ov_p INT,
    counted_census_night_home_m INT,
    counted_census_night_home_f INT,
    counted_census_night_home_p INT,
    count_census_nt_ewhere_aust_m INT,
    count_census_nt_ewhere_aust_f INT,
    count_census_nt_ewhere_aust_p INT,
    indigenous_psns_aboriginal_m INT,
    indigenous_psns_aboriginal_f INT,
    indigenous_psns_aboriginal_p INT,
    indig_psns_torres_strait_is_m INT,
    indig_psns_torres_strait_is_f INT,
    indig_psns_torres_strait_is_p INT,
    indig_bth_abor_torres_st_is_m INT,
    indig_bth_abor_torres_st_is_f INT,
    indig_bth_abor_torres_st_is_p INT,
    indigenous_p_tot_m INT,
    indigenous_p_tot_f INT,
    indigenous_p_tot_p INT,
    birthplace_australia_m INT,
    birthplace_australia_f INT,
    birthplace_australia_p INT,
    birthplace_elsewhere_m INT,
    birthplace_elsewhere_f INT,
    birthplace_elsewhere_p INT,
    lang_spoken_home_eng_only_m INT,
    lang_spoken_home_eng_only_f INT,
    lang_spoken_home_eng_only_p INT,
    lang_spoken_home_oth_lang_m INT,
    lang_spoken_home_oth_lang_f INT,
    lang_spoken_home_oth_lang_p INT,
    australian_citizen_m INT,
    australian_citizen_f INT,
    australian_citizen_p INT,
    age_psns_att_educ_inst_0_4_m INT,
    age_psns_att_educ_inst_0_4_f INT,
    age_psns_att_educ_inst_0_4_p INT,
    age_psns_att_educ_inst_5_14_m INT,
    age_psns_att_educ_inst_5_14_f INT,
    age_psns_att_educ_inst_5_14_p INT,
    age_psns_att_edu_inst_15_19_m INT,
    age_psns_att_edu_inst_15_19_f INT,
    age_psns_att_edu_inst_15_19_p INT,
    age_psns_att_edu_inst_20_24_m INT,
    age_psns_att_edu_inst_20_24_f INT,
    age_psns_att_edu_inst_20_24_p INT,
    age_psns_att_edu_inst_25_ov_m INT,
    age_psns_att_edu_inst_25_ov_f INT,
    age_psns_att_edu_inst_25_ov_p INT,
    high_yr_schl_comp_yr_12_eq_m INT,
    high_yr_schl_comp_yr_12_eq_f INT,
    high_yr_schl_comp_yr_12_eq_p INT,
    high_yr_schl_comp_yr_11_eq_m INT,
    high_yr_schl_comp_yr_11_eq_f INT,
    high_yr_schl_comp_yr_11_eq_p INT,
    high_yr_schl_comp_yr_10_eq_m INT,
    high_yr_schl_comp_yr_10_eq_f INT,
    high_yr_schl_comp_yr_10_eq_p INT,
    High_yr_schl_comp_Yr_9_eq_M INT,
    High_yr_schl_comp_Yr_9_eq_F INT,
    High_yr_schl_comp_Yr_9_eq_P INT,
    High_yr_schl_comp_Yr_8_belw_M INT,
    High_yr_schl_comp_Yr_8_belw_F INT,
    High_yr_schl_comp_Yr_8_belw_P INT,
    High_yr_schl_comp_D_n_g_sch_M INT,
    High_yr_schl_comp_D_n_g_sch_F INT,
    High_yr_schl_comp_D_n_g_sch_P INT,
    Count_psns_occ_priv_dwgs_M INT,
    Count_psns_occ_priv_dwgs_F INT,
    Count_psns_occ_priv_dwgs_P INT,
    Count_Persons_other_dwgs_M INT,
    Count_Persons_other_dwgs_F INT,
    Count_Persons_other_dwgs_P INT
);

CREATE TABLE raw.g02 (
    LGA_CODE_2016 varchar null primary key,
    Median_age_persons INT,
    Median_mortgage_repay_monthly INT,
    Median_tot_prsnl_inc_weekly INT,
    Median_rent_weekly INT,
    Median_tot_fam_inc_weekly INT,
    Average_num_psns_per_bedroom decimal(32,2),
    Median_tot_hhd_inc_weekly INT,
    Average_household_size decimal(32,2)
);

