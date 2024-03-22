{% macro check_ingestion_warehouse_status(ingestion_warehouse = env_var("INGESTION_WAREHOUSE")) %}

  {{ log("Checking the state of the ingestion warehouse...", info = True) }}
  {% set freshness_condition = True if var('check_ingestion_timestamp') else False %}
  {% set status_condition = True if var('check_ingestion_status') else False %}

  {{ log('Will check for the following criteria:', info=True) }}

  {% if freshness_condition %}
    {{ log('- The ingestion warehouse was last resumed less than ' ~ var('max_data_age_in_minutes') ~ ' minutes ago.', info=True) }}
  {% endif %}
  
  {% if status_condition %}
    {{ log('- The ingestion warehouse is currently suspended.', info=True) }}
  {% endif %}

  {# Run a query to check the current status of the Snowflake warehouse, as well as when it was last resumed #}
  {% set main_query = "SHOW WAREHOUSES LIKE '" ~ ingestion_warehouse | upper ~ "';"%}
  {% set results_query = 'SELECT "state", "resumed_on" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()));'%}

  {% if execute %}
    {% do run_query(main_query) %}
    {% set results = dbt_utils.get_query_results_as_dict(results_query) %}

    {% set state = results['state'][0]%}
    {% set last_resumed_local_tz = results['resumed_on'][0].astimezone()%}
    {% set run_started_local_tz = run_started_at.astimezone()%}
    {% set diff = (run_started_local_tz - last_resumed_local_tz).total_seconds() / 60 %}

    {{ log("The current state of the ingestion warehouse is " ~ state ~ ".", info = True) }}
    {{ log("The ingestion warehouse was last resumed at " ~ last_resumed_local_tz.strftime('%Y-%m-%d %H:%M:%S') ~ ". ("~ diff | int ~ " minutes ago)", info = True)}}

    {% if freshness_condition and diff > var('max_data_age_in_minutes') %}
        {{ exceptions.raise_compiler_error('The ingestion warehouse has been inactive for more than '~ var('max_data_age_in_minutes') ~ ' minutes' ~'.') }}
    {% elif status_condition and state != 'SUSPENDED' %}
        {{ exceptions.raise_compiler_error('The ingestion warehouse is still active.') }}
    {% endif %}

    {{ log("All criteria have been met. Proceeding with next steps.", info = True)}}
  {% endif %}
{% endmacro %}