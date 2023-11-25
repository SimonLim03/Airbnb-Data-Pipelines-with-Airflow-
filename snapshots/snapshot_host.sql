{% snapshot host_snapshot %}

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
    HOST_NAME, 
    HOST_SINCE, 
    HOST_IS_SUPERHOST, 
    HOST_NEIGHBOURHOOD,
    LISTING_NEIGHBOURHOOD,
    SCRAPED_DATE,
    CURRENT_TIMESTAMP as ingestion_datetime 
from {{ source('raw', 'listings') }}

{% endsnapshot %}