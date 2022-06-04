{% macro protect(symbol) %}
{# NOTE: We currently simply remove all protected code #}
{% set protections = spec.protections(symbol, feature_set=feature_set) %}
{% if protections|length == 0 %}
{{ caller() }}
{% endif %}
{% endmacro %}
