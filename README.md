# Airbnb Data Pipelines using Airflow and DBT 

## Author
Name: Simon Lim

## Description
- Airbnb is an online-based marketing company that provides services to people seeking accommodation (Airbnb guests) to people looking for renting their properties (Airbnb hosts). Airbnb offers a variety of the rental property’s options, including apartments, homes, boats, townhouses or private rooms. While Airbnb records millions of various information in 191 countries, including density of rentals across regions, price variations across rentals and host-guest interactions (e.g., number of reviews). In this project, only data in Sydney are used with specific date range from May 2020 to April 2021.
- In addition, the Census of Population and Housing (Census) is Australia’s largest statistical data collection that is undertaken and managed by the Australian Bureau of Statistics (ABS). Census aims at accurately collecting data regarding the key characteristics of Australians in each region. The data of key characteristics generated from Census will be used along with Airbnb data, in order to extract insights and further analyse and answer business questions.
- In terms of the following contexts, the objective of the project is to build production-ready data pipelines with Airflow, Data Build Tool and Postgres SQL. The procedure of the project includes building production-ready data pipelines with Airflow, processing and cleaning data using DBT ELT pipelines, design the architecture of a data warehouse on Postgres and finally analyse and extract valuable insights. In this project, Airflow is used to load data, DBT is used to design a data warehouse and Postgres is used to analyse and answer business questions.

![image](https://github.com/SimonLim03/Airbnb-Data-Pipelines-with-Airflow-/assets/150989115/ffe9a7b2-8c4e-4c29-a7eb-ef0a2168d213)




## Presentation of Dataset
- There are three kinds of datasets generated from Airbnb and Census, including 12 months of Airbnb listing data for Sydney, G01(“Selected Person Characteristics by Sex”) and G02 (“Selected Medians and Averages”) Census data and lastly a dataset, containing LGAs code, LGA names and suburb names, which will help to join other datasets in later stage.
- Airbnb listing dataset contains information, such as host_name, host_since, host_neighbouthood, listing_neighbourhood, property_type, room_type, accommodates, price, availabilities and number and scores of reviews. Perhaps, it is assumed that Airbnb listing dataset can be snapshotted into three dimensions, including host, property type and room type. Furthermore, Census tables (i.e., G01 and G02) and LGAs tables can be also used as dimensions tables.
- Lastly, Airbnb listing dataset contains some null values and data quality issues in some columns (e.g., string values in numeric column). In this regard, it is predicted that when loading data in Airflow, wrong data type of column can potentially raise an error. Therefore, appropriate matched data type for each column would be necessary when loading data in Airflow. 


## Results of Analysis and Machine Learning
- Refer to the hand-over report for outcomes of the project
