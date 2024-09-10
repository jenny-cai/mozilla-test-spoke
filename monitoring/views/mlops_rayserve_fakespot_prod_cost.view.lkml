view: mlops_rayserve_fakespot_prod_cost {
  derived_table: {
    sql: SELECT
        *
      FROM `moz-fx-data-shared-prod.monitoring_derived.rayserve_cost_fakespot_tenant_prod_v1`
      ;;
  }

  dimension: invoice_day {
    description: "The invoice day"
    type: date_time
    sql: ${TABLE}.invoice_day ;;
  }

  dimension: total_compute_cost_per_day {
    description: "Aggregated compute cost (in USD) of all Ray Serve workloads on a day"
    type: number
    sql: ${TABLE}.total_cost_per_day ;;
  }

}
