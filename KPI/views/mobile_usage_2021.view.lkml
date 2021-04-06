view: mobile_usage_2021 {
  derived_table: {
    sql:
      with
        base as (
      select
          submission_date,
          app_name,
          canonical_app_name,
          sum(dau) as dau,
          sum(wau) as wau,
          sum(mau) as mau,
          sum(cdou) as cdou
      from
          ${mobile_usage_fields.SQL_TABLE_NAME} AS mobile_usage_fields
      where
          {% condition mobile_usage_2021.campaign %} campaign {% endcondition %}
          AND {% condition mobile_usage_2021.channel %} channel {% endcondition %}
          AND {% condition mobile_usage_2021.country %} country {% endcondition %}
          AND {% condition mobile_usage_2021.country_name %} country_name {% endcondition %}
          AND {% condition mobile_usage_2021.distribution_id %} distribution_id {% endcondition %}
          AND {% condition mobile_usage_2021.id_bucket %} id_bucket {% endcondition %}
          AND {% condition mobile_usage_2021.os %} os {% endcondition %}
      group by 1,2,3 )

      select
        *,
        avg(dau) over (partition by app_name order by submission_date rows between 6 preceding and current row) as dau_7day_ma
      from base
      ;;
  }

  filter: campaign {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.campaign
    type: string
    description: "The (UTM) campaign that profiles are attributed to."
  }

  filter: channel {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.channel
    type: string
    description: "Mobile Firefox release channel."
  }

  filter: country {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.country
    type: string
    description: "Country codes derived from the client's IP address."
  }

  filter: country_name {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.country_name
    type: string
    description: "Full country names derived from the client's IP address."
  }

  filter: distribution_id {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.distribution_id
    type: string
    description: "The distribution ID, through a partner or a repack."
  }

  filter: id_bucket {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.id_bucket
    type: number
    description: "For sampling: each client_id is mapped to one of twenty id_buckets."
  }

  filter: os {
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.os
    type: string
    description: "Profile's Operating System."
  }

  dimension: app_name {
    type: string
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.app_name
    sql: ${TABLE}.app_name ;;
    description: "Snake-cased mobile application name."
  }

  dimension: canonical_app_name {
    type: string
    suggest_explore: mobile_usage_fields
    suggest_dimension: mobile_usage_fields.canonical_app_name
    sql: ${TABLE}.canonical_app_name ;;
    description: "Human readable mobile application name."
  }

  dimension: date {
    type: date
    convert_tz: no
    sql: CAST(${TABLE}.submission_date AS TIMESTAMP) ;;
  }

  measure: cdou {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.cdou ;;
    description: "Cumulative Days of Use, in that calendar year."
  }

  measure: dau {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau ;;
    description: "Daily Active Users."
  }

  measure: dau_7day_ma {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.dau_7day_ma ;;
    hidden: yes
  }

  measure: mau {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.mau ;;
    description: "Monthly Active Users."
  }

  measure: recent_cdou {
    type: max
    value_format: "#,##0"
    sql: ${TABLE}.cdou ;;
    hidden: yes
  }

  measure: recent_date {
    type: date
    sql: MAX(CAST(${TABLE}.submission_date AS TIMESTAMP)) ;;
    hidden: yes
  }

  measure: wau {
    type: sum
    value_format: "#,##0"
    sql: ${TABLE}.wau ;;
    description: "Weekly Active Users."
  }

  measure: delta_from_forecast {
    type: number
    value_format: "0.000%"
    sql: (${recent_cdou} / ${mobile_prediction.recent_cdou_forecast} ) - 1 ;;
    description: "Relative (given as a fraction) difference between actual CDOU and forecasted CDOU."
  }

  measure: delta_from_forecast_format{
    type: number
    hidden: yes
    sql: ${delta_from_forecast} ;;
    html:
    {% assign target_delta = mobile_usage_2021.delta_from_target._value | times: 100 %}
    {% assign forecast_delta = mobile_usage_2021.delta_from_forecast._value | times: 100 %}
    {% assign app_type = mobile_usage_2021.app_name._value %}
    <div class="topline" style="font-size: 30px; background-color: #d7d7db; color:#000000; padding: 12px; margin: 12px;">
      <center>
      <h1><b><u><font color="#ff9400">Progress in {{ mobile_usage_2021.canonical_app_name._value }} Cumulative Days of Use (CDOU) As Of {{ mobile_usage_2021.recent_date._rendered_value }}</font></u></b></h1>
      {% if app_type == 'fennec_fenix' or app_type == 'firefox_ios' %} <img src="https://d33wubrfki0l68.cloudfront.net/06185f059f69055733688518b798a0feb4c7f160/9f07a/images/product-identity-assets/firefox.png" alt="Firefox Logo" style="width:300px;height:300px;float:right"> {% else %} <img src="https://design.firefox.com/product-identity/firefox-focus/firefox-logo-focus.png" alt="Firefox Focus Logo" style="width:200px;height:200px;float:right"> {% endif %}
      {% if app_type == 'fennec_fenix' or app_type == 'firefox_ios' %} <img src="https://d33wubrfki0l68.cloudfront.net/06185f059f69055733688518b798a0feb4c7f160/9f07a/images/product-identity-assets/firefox.png" alt="Firefox Logo" style="width:300px;height:300px;float:left"> {% else %} <img src="https://design.firefox.com/product-identity/firefox-focus/firefox-logo-focus.png" alt="Firefox Focus Logo" style="width:200px;height:200px;float:left"> {% endif %}
      <h1><b><font color= "#45a1ff">Current CDOU: {{ mobile_usage_2021.recent_cdou._rendered_value }}</font></b></h1>
      <p><em>{% if target_delta > 0 %} <font color="#30e60b">▲ {{ mobile_usage_2021.delta_from_target._rendered_value }}</font> {% else %} <font color="#ff0039">▼ {{ mobile_usage_2021.delta_from_target._rendered_value }}</font> {% endif %}  from +{{ mobile_usage_2021.target_lift._rendered_value }} Target Pace ({{ mobile_prediction.recent_cdou_target._rendered_value }})</em></p>
      <p>{% if forecast_delta > 0 %} <font color="#30e60b">▲ {{ mobile_usage_2021.delta_from_forecast._rendered_value }}</font> {% else %} <font color="#ff0039">▼ {{ mobile_usage_2021.delta_from_forecast._rendered_value }}</font> {% endif %} from Forecast ({{ mobile_prediction.recent_cdou_forecast._rendered_value }})</p>
      <a href="#explainer" style="color: #0000EE"><u>Explainer</u></a>
      </center>
    </div>
   ;;
  }

  measure: delta_from_target {
    type: number
    value_format: "0.000%"
    sql: (${recent_cdou} / ${mobile_prediction.recent_cdou_target} ) - 1 ;;
    description: "Relative (given as a fraction) difference between actual CDOU and targeted CDOU."
  }

  measure: delta_from_forecast_count {
    type: number
    value_format: "#,##0"
    sql: ${cdou} - ${mobile_prediction.cdou_forecast}  ;;
    description: "Absolute (given as a whole number) difference between actual CDOU and forecasted CDOU."

  }

  measure: delta_from_target_count {
    type: number
    value_format: "#,##0"
    sql: ${cdou} - ${mobile_prediction.cdou_target}  ;;
    description: "Absolute (given as a whole number) difference between actual CDOU and targeted CDOU."

  }

  measure: target_lift {
    type: number
    value_format: "0.0%"
    sql: (${mobile_prediction.recent_cdou_target} / ${mobile_prediction.recent_cdou_forecast} ) - 1 ;;
    hidden: yes
  }

}
