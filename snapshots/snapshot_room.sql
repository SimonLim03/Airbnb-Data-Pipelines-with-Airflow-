{% snapshot room_snapshot %}

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
    ROOM_TYPE,
    NUMBER_OF_REVIEWS,
    REVIEW_SCORES_RATING, 
    REVIEW_SCORES_ACCURACY, 
    REVIEW_SCORES_CLEANLINESS, 
    REVIEW_SCORES_CHECKIN, 
    REVIEW_SCORES_COMMUNICATION, 
    REVIEW_SCORES_VALUE,
    SCRAPED_DATE,
    CURRENT_TIMESTAMP as ingestion_datetime
from {{ source('raw', 'listings') }}

{% endsnapshot %}