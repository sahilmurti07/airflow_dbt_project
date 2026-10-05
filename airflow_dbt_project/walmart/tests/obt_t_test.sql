{{config(severity='warn')}}
select 1 
from {{ref("obt_b")}}
where 
obt_b.order_id is null
or 
obt_b.product_id is null
or 
obt_b.customer_id is null
or 
obt_b.store_id is null
or 
obt_b.order_item_id is null
or 
obt_b.store_id is null