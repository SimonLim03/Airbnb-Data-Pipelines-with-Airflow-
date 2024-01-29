# Airbnb Data Pipelines using Airflow and DBT 

## Author
Name: Simon Lim

## Description
- Airbnb is an online-based marketing company that provides services to people seeking accommodation (Airbnb guests) to people looking for renting their properties (Airbnb hosts). Airbnb offers a variety of the rental property’s options, including apartments, homes, boats, townhouses or private rooms. While Airbnb records millions of various information in 191 countries, including density of rentals across regions, price variations across rentals and host-guest interactions (e.g., number of reviews). In this project, only data in Sydney are used with specific date range from May 2020 to April 2021.

- In addition, the Census of Population and Housing (Census) is Australia’s largest statistical data collection that is undertaken and managed by the Australian Bureau of Statistics (ABS). Census aims at accurately collecting data regarding the key characteristics of Australians in each region. The data of key characteristics generated from Census will be used along with Airbnb data, in order to extract insights and further analyse and answer business questions.

- In terms of the following contexts, the objective of the project is to build production-ready data pipelines with Airflow, Data Build Tool and Postgres SQL. The procedure of the project includes building production-ready data pipelines with Airflow, processing and cleaning data using DBT ELT pipelines, design the architecture of a data warehouse on Postgres and finally analyse and extract valuable insights. In this project, Airflow is used to load data, DBT is used to design a data warehouse and Postgres is used to analyse and answer business questions.
  
- Data Build Tool and Postgres SQL. Data pipelines and analysis on Airbnb provided an overview of the average revenue, total number of stays and the proportions of age ranges depending on different suburb, property type and room type.

![image](https://github.com/SimonLim03/Airbnb-Data-Pipelines-with-Airflow-/assets/150989115/ffe9a7b2-8c4e-4c29-a7eb-ef0a2168d213)
![image](https://github.com/SimonLim03/Airbnb-Data-Pipelines-with-Airflow-/assets/150989115/0d0e02be-0751-40b1-9975-a6f0ba8dd36e)




## Presentation of Dataset
- There are three kinds of datasets generated from Airbnb and Census, including 12 months of Airbnb listing data for Sydney, G01(“Selected Person Characteristics by Sex”) and G02 (“Selected Medians and Averages”) Census data and lastly a dataset, containing LGAs code, LGA names and suburb names, which will help to join other datasets in later stage.
- Airbnb listing dataset contains information, such as host_name, host_since, host_neighbouthood, listing_neighbourhood, property_type, room_type, accommodates, price, availabilities and number and scores of reviews. Perhaps, it is assumed that Airbnb listing dataset can be snapshotted into three dimensions, including host, property type and room type. Furthermore, Census tables (i.e., G01 and G02) and LGAs tables can be also used as dimensions tables.
- Lastly, Airbnb listing dataset contains some null values and data quality issues in some columns (e.g., string values in numeric column). In this regard, it is predicted that when loading data in Airflow, wrong data type of column can potentially raise an error. Therefore, appropriate matched data type for each column would be necessary when loading data in Airflow. 


## Pipeline of the Project
- 0. Public and private IP address were obtained and applied into Airflow (private) and Postgres (public).

### 1. Data Loading into Postgres using Airflow
- 1.	Airbnb listing dataset, LGA datasets and Census datasets were uploaded into Airflow storage bucket. 
- 2.	A raw schema and the relevant raw tables, which represent Airbnb, Census and LGA datasets, were created on Postgres. The relevant raw tables include raw.listings, raw.nsw_lga, raw.nsw_suburb, raw.g01, raw.g02. 
- 3.	An Airflow Dag file, that was used to read the datasets and insert the raw data into the raw schema, was created. The names of columns in raw tables on Postgres and column names in Dag file were identical with appropriate data types based on values of each column. The Dag file was then uploaded into Airflow storage bucket, which was automatically processed in Airflow and updated on Postgres.   

### 2. Design a Data Warehouse using DBT
#### 2.1. Raw/Snapshot (table)
- Five raw tables were already created in Airflow loading stage, including raw.listings, raw.nsw_lag, raw.nsw_suburb, raw.g01, raw.g02. 
-	Three different dimensions from raw.listings were snapshotted with each dimension representing host, property_type and room_type. Mutually, ‘host_id’ was used as a unique key for all three snapshots and ‘scraped_date’ was used as an updated date.

#### 2.2. Staging (view)
- stg_G01 and stg_G02:  A column, ‘lga_code_2016’ was transformed from data format of ‘LGA*****’ to ‘*****’ using SUBSTRING function and then its column name was renamed as ‘lga_code’ with data type integer. 
- Stg_LGA: There was no change from a raw table.
- Stg_Suburb: All columns (‘lga_name’ and ‘suburb_name’) were in capital letters. Hence, they were appropriately changed to match the format with ‘lga_name’ in stg_LGA. Only first letter in each word was set as a capital letter and other letters were fixed as lower cases.
- Stg_Host: There were some null values in several columns, including ‘host_name’, ‘host_since’, ‘host_is_superhost’ and ‘host_neighbourhood’. Null values were cleaned by filling them with default values, ‘unknown’ for string values, 0 for numeric values and ‘false’ for Boolean values. Also, date columns such as ‘host_since’, ‘scraped_date’, ‘dbt_valid_from’ and ‘dbt_valid_to’ were converted to date type.  
- Stg_Property: Some data type transformations were performed at this stage. For example, ‘price’ column was converted from varchar type to float type and ‘has_availablity’ was converted to Boolean type and ‘scraped_date’ was converted to date type. 
- Stg_room: There were some null values in integer columns, including ‘review_scores_rating’, ‘review_scores_accuracy’, ‘review_scores_cleanliness’, ‘review_scores_checkin’, ‘review_scores_communication’ and ‘review_scores_value’. Null values were filled with 0. Also, date columns were converted to date type like other snapshots.
- Stg_listing: This staging view included all the cleaned and transformed columns from stg_host, stg_property and stg_room. It would be used as a fact table in warehouse stage.

#### 2.3. Warehouse (table)
-	While all of dimension staging views were directly transformed into warehouse table without any change, this stage focused on a fact table, which is fact_listings. All the columns in the fact table were brought from corresponding dimension tables. Any value that was not included in corresponding dimension tables was set as a default values (i.e., ‘unknown’, 0 or ‘false’).
- Lastly, the fact table was joined with few dimension tables, including stg_LGA (on listing_neighbourhood, host_neighbourhood = lga_name) and stg_Suburb (on host_neighbourhood = lga_name)
-	Particularly, ‘host_neighbourhood’ included values that are in either ‘lga_name’ or ‘suburb_name’. Hence, both ‘lga_name’ and ‘suburb_name’ were used to match values in ‘host_neighbourhood’.

#### 2.4. Datamart (view)

##### a. Dm_listing_neighbourhood
-	active listings 
-	active listings rate
-	minimum, maximum, median and average of price for active listings 
-	superhost rate
-	average of review scores rating for active listings
-	percentage change for active listings
-	percentage change for inactive listings
-	total number of stays
-	average estimated revenue per active listings

##### b. dm_property_type
-	active listings 
-	active listings rate
-	minimum, maximum, median and average of price for active listings 
-	superhost rate
-	average of review scores rating for active listings
-	percentage change for active listings
-	percentage change for inactive listings
-	total number of stays
-	average estimated revenue per active listings

##### c. dm_host_neighbourhood
-	number of distinct host
-	estimated revenue
-	estimated revenue per distinct host



