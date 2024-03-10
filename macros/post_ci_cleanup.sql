{% macro post_ci_cleanup(dry_run = true) %}

{% if target.schema == 'CI_SCHEMA'%}
  {% set query = "DROP SCHEMA IF EXISTS "  ~ target.database | upper ~ "." ~ target.schema | upper %}

    {% if not (dry_run | as_bool) %}
        {% set result = run_query(query) %}
        {% if execute %}
            {% set output = result.columns[0].values()[0] %}
        {% else %}
            {% set output = 'Something went wrong, please check your code.' %}
        {% endif %}
        {% do log(output, info = True) %}
    {% else %}
        {% do log(query ~ ";", info = True) %}
    {% endif %}
{% endif %}
{% endmacro %}