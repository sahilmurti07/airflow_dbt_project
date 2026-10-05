select 
distinct
product_id,
product_name,
price,
category,
brand,
product_created_timestamp,
product_updated_timestamp,
product_active,
product_processed_at,
current_timestamp() as product_gold_processed_at
from {{ref("obt_b")}}