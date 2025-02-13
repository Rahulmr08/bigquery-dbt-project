with
    fct_orders as (select * from {{ ref("fct_orders") }}),
    dim_customers as (select * from {{ ref("dim_customers") }})

    ranked_orders as (
        select
            cust.customer_id,
            cust.first_name,
            sum(ord.total_amount) as global_paid_amount,
            row_number() over (order by sum(ord.total_amount) desc) as rank
        from fct_orders as ord
        left join dim_customers as cust on ord.customer_id = cust.customer_id
        where ord.is_order_completed = 1
        group by cust.customer_id, cust.first_name
    )
select customer_id, first_name, global_paid_amount
from ranked_orders
where rank <= 10
