# include: "//mozilla/websites/views/limited_historical_google_search_console_by_page.view.lkml"

view: +limited_historical_google_search_console_by_page {
  dimension: impressions {
    hidden: yes
  }
  measure: total_impressions {
    type: sum
    sql: ${TABLE}.impressions ;;
    description: "The number of times that search results with a link to the page were shown to a user."
  }

  dimension: clicks {
    hidden: yes
  }
  measure: total_clicks {
    type: sum
    sql: ${TABLE}.clicks ;;
    description: "The number of times a user clicked a search result link to the page."
  }

  measure: click_through_rate {
    type: number
    sql: SAFE_DIVIDE(${total_clicks}, ${total_impressions}) ;;
    value_format_name: percent_2
    label: "Click-Through Rate"
    description: "The total click count divided by the total impression count."
  }

  dimension: average_position {
    hidden: yes
  }
  measure: total_average_position_times_impressions {
    type: sum
    sql: ${TABLE}.average_position * ${TABLE}.impressions ;;
    hidden: yes
  }
  measure: average_result_position {
    type: number
    sql: SAFE_DIVIDE(${total_average_position_times_impressions}, ${total_impressions}) ;;
    value_format_name: decimal_2
    description: "The average position of the page in the search results, where `1` is the topmost position."
  }

  measure: distinct_page_url_count {
    type: count_distinct
    sql: ${page_url} ;;
  }

  measure: distinct_query_count {
    type: count_distinct
    sql: ${query} ;;
  }
}