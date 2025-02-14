{# Macro that considering the target name,
limits the amount of data queried for the nbr_months_of_data defined #}
{% macro limit_dataset_if_not_deploy_env(column_name, nbr_months_of_data) %}
-- limit the amount of data queried if not in the deploy environment.
{% if target.name != 'deploy' %}
where {{ column_name }} > DATE_SUB(CURRENT_DATE(), INTERVAL {{ nbr_months_of_data }}
MONTH)
{% endif %}
{% endmacro %}
Then, in the fct_orders model, include the code from Example 5-17 at the bottom
after the left join.
Example 5-17. Call limit_dataset_if_not_deploy_env macro from fct_orders
with orders as (
 select * from {{ ref('stg_jaffle_shop_orders' )}}
),
payment_type_orders as (
 select * from {{ ref('int_payment_type_amount_per_order' )}}
)
select
 ord.order_id,
 ord.customer_id,
ord.order_date,
 pto.cash_amount,
 pto.credit_amount,
 pto.total_amount,
 case
 when status = 'completed'
 then 1
 else 0
 end as is_order_completed
from orders as ord
left join payment_type_orders as pto ON ord.order_id = pto.order_id
-- Add macro here
{{- limit_dataset_if_not_deploy_env('order_date', 3) }}