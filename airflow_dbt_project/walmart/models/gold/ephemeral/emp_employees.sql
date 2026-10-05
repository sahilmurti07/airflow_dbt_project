select 
distinct
employee_id,
employee_store_id,
employee_first_name,
employee_last_name,
employee_email,
employee_job_title,
employee_salary,
employee_created_timestamp,
employee_updated_timestamp,
employee_active,
employee_processed_at,
current_timestamp() as employee_gold_processed_at
from {{ref("obt_b")}}