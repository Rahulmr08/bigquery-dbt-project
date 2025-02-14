{% macro get_payment_types() %}
    {% set payment_type_query %}
 select
 distinct payment_type
 from {{ ref('stg_stripe_order_payments') }}
 order by 1
    {% endset %}
    {% set results = run_query(payment_type_query) %}
    {% if execute %}
        {# Return the first column #}
        {% set results_list = results.columns[0].values() %}
    {% else %} {% set results_list = [] %}
    {% endif %}
    {{ return(results_list) }}
{% endmacro %}
