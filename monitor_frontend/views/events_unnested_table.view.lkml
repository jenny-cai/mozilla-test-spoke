include: "//looker-hub/monitor_frontend/views/events_unnested_table.view.lkml"

view: +events_unnested_table {

  dimension: event_extra__user_id {
    description: "Unique user ID"
    hidden: yes
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'user_id') ;;
  }

  dimension: event_extra__path {
    description: "The URL or path of the page"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'path') ;;
    group_label: "Event Extra"
    group_item_label: "Page Path"
  }

  dimension: event_extra__utm_campaign {
    description: "Marketing and attribution UTM campaign"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'utm_campaign') ;;
    group_label: "Event Extra"
    group_item_label: "UTM Campaign"
  }

  dimension: event_extra__utm_medium {
    description: "Marketing and attribution UTM medium"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'utm_medium') ;;
    group_label: "Event Extra"
    group_item_label: "UTM Medium"
  }

  dimension: event_extra__utm_source {
    description: "Marketing and attribution UTM source"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'utm_source') ;;
    group_label: "Event Extra"
    group_item_label: "UTM Source"
  }

  dimension: event_extra__utm_term {
    description: "Marketing and attribution UTM term"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'utm_term') ;;
    group_label: "Event Extra"
    group_item_label: "UTM Term"
  }

  dimension: event_extra__field_id {
    description: "The location of an input field that determines where on the web page the interaction is occurring"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'field_id') ;;
    group_label: "Event Extra"
    group_item_label: "Field ID"
  }

  dimension: event_extra__button_id {
    description: "The ID of the button that was clicked on, used as a way to identify where on the page the interaction is located"
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'button_id') ;;
    group_label: "Event Extra"
    group_item_label: "Button ID"
  }

  dimension: event_extra__popup_id {
    description: ""
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'popup_id') ;;
    group_label: "Event Extra"
    group_item_label: "Popup ID"
  }

  dimension: event_extra__link_id {
    description: ""
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'link_id') ;;
    group_label: "Event Extra"
    group_item_label: "Link ID"
  }

  dimension: event_extra__dashboard_tab {
    description: "Either `action-needed` or `fixed`, depending on where in the dashboard the event is recorded."
    type: string
    sql: `mozfun.map.get_key`(${TABLE}.event_extra, 'dashboard_tab') ;;
    group_label: "Event Extra"
    group_item_label: "Dashboard Tab"
  }

  dimension: event_extra__legacy_user {
    description: "A flag indicating whether the user logged into their dashboard previous to the Monitor premium launch."
    type:  yesno
    sql: SAFE_CAST(`mozfun.map.get_key`(${TABLE}.event_extra, 'legacy_user') AS BOOL) ;;
    group_label: "Event Extra"
    group_item_label: "Legacy User"
  }

  dimension: event_extra__breach_count {
    description: "A count of breaches displayed on the user’s dashboard"
    type: number
    sql: SAFE_CAST(`mozfun.map.get_key`(${TABLE}.event_extra, 'breach_count') AS INTEGER) ;;
    group_label: "Event Extra"
    group_item_label: "Breach Count"
  }

  dimension: event_extra__broker_count {
    description: "A count of data brokers displayed on the user's dashboard"
    type: number
    sql: SAFE_CAST(`mozfun.map.get_key`(${TABLE}.event_extra, 'broker_count') AS INTEGER) ;;
    group_label: "Event Extra"
    group_item_label: "Broker Count"
  }

  measure: user_count {
    description: "Use this for counting lifetime orders across many users"
    type: count_distinct
    sql: ${event_extra__user_id} ;;
  }
}
