select 
order_id,
order_item_id,
customer_id,
product_id,
employee_id,
store_id,
total_amount,
quantity,
unit_price,
line_amount
from
{{ref("obt_b")}}

