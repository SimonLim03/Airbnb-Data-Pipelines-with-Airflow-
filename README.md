# New York City Taxi Data Processing with Spark

## Author
Name: Simon Lim

## Description
- The New York City Taxi and Limousine Commission (TLC) is the agency responsible for 
regulating and managing New York City’s taxi cabs. TLC regularly records millions of trips 
information from both yellow and green taxi cabs, including pick-up and drop-off 
dates/times, locations, trip distances, payment types and total amount etc. While yellow 
taxi cabs are the iconic taxi vehicles, which can pick up passengers anywhere in the city, 
green taxi cabs can only pick up passengers in certain designated areas.
- In this regard, the objective of the project is to analyse a large dataset and obtain 
meaningful outcomes using Spark in Databricks. The procedure of the project includes data 
ingestion and preparation, data transformation and analysis and finally training a Machine 
Learning algorithm for predicting total amount of trips. In this project, Databricks is a main 
platform used to perform data preparation, cleaning and machine learning.

![image](https://github.com/SimonLim03/Data-Processing-with-Databricks-Spark/assets/150989115/eb33a883-7ffc-4569-b690-7445e5eb9e0d)



## Presentation of Dataset
- There are yellow and green taxi cabs datasets from 2015 to 2022 for each taxicab and they 
are all parquet files. Each dataset contains various information of trips, including VendorID, 
pickup_datetime, dropoff_datetime, LocationID, passenger_count, trip_distance, 
fare_amount and total_amount etc. Also, there is a location dataset, including LocationID, 
Borough, zone and service_zone.
- Each 2015-2022 dataset for yellow and green taxi contains a massive amount of data and 
therefore they have been compressed by saving them as parquet files. The total number of 
yellow taxi trips is 663055251 and the total number of green taxi trips is 66200401. At the 
beginning, it was assumed that a massive amount of data would considerably make a delay 
for the processing of data cleaning, analysis and machine learning action phases. Hence, the 
process of saving and re-loading dataframes would be essential to reduce the significant 
processing delay.
- In terms of datasets, parquet files are mainly used in this project, as they compress data and 
hence be able to include a more massive amount of data.


## Results of Analysis and Machine Learning
- Refer to the hand-over report for outcomes of the project
