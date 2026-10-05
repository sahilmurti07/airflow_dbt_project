select 
distinct
order_id,
order_item_id,
order_timestamp,
order_status,
payment_method,
order_active,
order_created_timestamp,
order_updated_timestamp,
order_processed_at,
obt_processed_at,
current_timestamp() as order_gold_processed_at
from {{ref("obt_b")}}