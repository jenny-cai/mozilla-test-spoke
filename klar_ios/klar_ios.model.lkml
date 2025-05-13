connection: "bigquery"
label: "Firefox Klar for iOS"
# include: "//mozilla/klar_ios/explores/*"
# include: "//mozilla/klar_ios/views/metrics.view"
# include: "views/*"
# include: "explores/*"
# include: "dashboards/*"

view: +metrics {
  dimension: metrics__labeled_counter__browser_search_in_content {
    label: "Browser Search In Content"
    hidden: yes
    sql: ${TABLE}.metrics.labeled_counter.browser_search_in_content ;;
    group_label: "Browser Search"
    group_item_label: "In Content"
  }
}