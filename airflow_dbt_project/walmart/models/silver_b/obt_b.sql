{%
    set configs = [
        {
        "table" : "walmart.silver_t.orders_t",
        "columns": 
        """
        o.order_id as order_id,
        o.order_timestamp as order_timestamp,
        o.payment_method as payment_method,
        o.order_status as order_status,
        o.total_amount as total_amount,
        o.created_timestamp as order_created_timestamp,
        o.updated_timestamp as order_updated_timestamp,
        o.is_active as order_active,
        o.processed_at as order_processed_at,
        current_timestamp() as obt_processed_at
        """,
        "alias" : "o"
    },
    {
        "table" : "walmart.silver_t.orders_items_t",
        "columns": 
        """
        oi.order_item_id as order_item_id,
        oi.quantity as quantity,
        oi.unit_price as unit_price,
        oi.line_amount as line_amount,
        oi.created_timestamp as order_item_created_timestamp,
        oi.updated_timestamp as order_item_updated_timestamp,
        oi.is_active as order_item_active,
        oi.processed_at as order_item_processed_at
        """,
        "alias" : "oi",
        "join_condition" : "o.order_id = oi.order_id"
    },
    {
        "table" : "walmart.silver_t.products_t",
        "columns": 
        """
        p.product_id as product_id,
        p.product_name as product_name,
        p.category as category,
        p.brand as brand,
        p.price as price,
        p.created_timestamp as product_created_timestamp,
        p.updated_timestamp as product_updated_timestamp,
        p.is_active as product_active,
        p.processed_at as product_processed_at
        """,
        "alias" : "p",
        "join_condition" : "oi.product_id = p.product_id"
    },
    {
        "table" : "walmart.silver_t.stores_t",
        "columns": 
        """
        s.store_id as store_id,
        s.store_name as store_name,
        s.city as store_city,
        s.province as store_province,
        s.country as store_country,
        s.created_timestamp as store_created_timestamp,
        s.updated_timestamp as store_updated_timestamp,
        s.is_active as store_active,
        s.processed_at as store_processed_at
        """,
        "alias" : "s",
        "join_condition" : "o.store_id = s.store_id"
    },
    {
        "table" : "walmart.silver_t.customers_t",
        "columns": 
        """
        c.customer_id as customer_id,
        c.first_name as customer_first_name,
        c.last_name as customer_last_name,
        c.email as customer_email,
        c.phone as customer_phone,
        c.city as customer_city,
        c.province as customer_province,
        c.country as customer_country,
        c.created_timestamp as customer_created_timestamp,
        c.updated_timestamp as customer_updated_timestamp,
        c.is_active as customer_active,
        c.processed_at as customer_processed_at
        """,
        "alias" : "c",
        "join_condition" : "o.customer_id = c.customer_id"
    },
    {
        "table" : "walmart.silver_t.employees_t",
        "columns": 
        """
        e.employee_id as employee_id,
        e.store_id as employee_store_id,
        e.first_name as employee_first_name,
        e.last_name as employee_last_name,
        e.email as employee_email,
        e.job_title as employee_job_title,
        e.salary as employee_salary,
        e.created_timestamp as employee_created_timestamp,
        e.updated_timestamp as employee_updated_timestamp,
        e.is_active as employee_active,
        e.processed_at as employee_processed_at
        """,
        "alias" : "e",
        "join_condition" : "o.store_id = e.store_id"
    }
    ]
%}

select 
{% for config in configs %}
    {{ config['columns'] }}{%if not loop.last %},{% endif %}
{% endfor %}    
from 
{% for config in configs %}
    {% if loop.first %}
        {{config['table']}} {{config['alias']}}
    {% else %}
left join {{config['table']}} {{config['alias']}} 
    on {{config['join_condition']}}
    {% endif %}
{% endfor %}    