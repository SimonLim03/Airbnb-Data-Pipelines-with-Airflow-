{% snapshot property_snapshot %}

{{
        config(
          target_schema='raw',
          strategy='timestamp',
          unique_key='HOST_ID',
          updated_at='SCRAPED_DATE'
        )
    }}

SELECT DISTINCT ON (HOST_ID) 
    HOST_ID,
    PROPERTY_TYPE, 
    ACCOMMODATES, 
    PRICE, 
    HAS_AVAILABILITY, 
    AVAILABILITY_30, 
    NUMBER_OF_REVIEWS,
    SCRAPED_DATE,
    CURRENT_TIMESTAMP as ingestion_datetime
from {{ source('raw', 'listings') }}

{% endsnapshot %}