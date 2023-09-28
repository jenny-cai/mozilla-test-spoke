
view: android_default_browser_metrics {
  derived_table: {
    sql: WITH dau_segments AS 
          (SELECT submission_date, SUM(DAU) as dau
          FROM `moz-fx-data-shared-prod.telemetry.active_users_aggregates` 
          WHERE app_name = 'Fenix'
          --AND channel = 'release'
          AND submission_date >= '2021-01-01'
          GROUP BY 1),
          
      
      product_features AS
      (SELECT
          client_info.client_id,
          DATE(submission_timestamp) as submission_date,
          COALESCE(SUM(CASE WHEN metrics.boolean.metrics_default_browser THEN 1 ELSE 0 END)) AS metrics_default_browser
          FROM `mozdata.fenix.metrics`
      where DATE(submission_timestamp) >= '2021-01-01'
      AND sample_id = 0
      group by 1,2),
      
      product_features_agg AS
      (SELECT
          submission_date,
          --metrics_default_browser
          100*COUNT(DISTINCT CASE WHEN metrics_default_browser > 0 THEN client_id END) AS metrics_default_browser_users,
          100*COALESCE(SUM(metrics_default_browser), 0) AS metrics_default_browser,
      FROM product_features
      where submission_date >= '2021-01-01'
      group by 1)
          
          
      select d.submission_date
      , dau
      , metrics_default_browser_users
      , metrics_default_browser
      from dau_segments d
      LEFT JOIN product_features_agg p
      ON d.submission_date = p.submission_date ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: submission_date {
    type: date
    datatype: date
    sql: ${TABLE}.submission_date ;;
  }

  dimension: dau {
    type: number
    sql: ${TABLE}.dau ;;
  }

  dimension: metrics_default_browser_users {
    type: number
    sql: ${TABLE}.metrics_default_browser_users ;;
  }

  dimension: metrics_default_browser {
    type: number
    sql: ${TABLE}.metrics_default_browser ;;
  }

  set: detail {
    fields: [
        submission_date,
	dau,
	metrics_default_browser_users,
	metrics_default_browser
    ]
  }
}
