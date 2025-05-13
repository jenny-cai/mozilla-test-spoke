# include: "//mozilla/review_checker/views/android_events.view.lkml"


view: +android_events {

  dimension: client_id {
    #primary_key: yes
    sql: ${TABLE}.client_id ;;
    hidden: yes
  }

  dimension: client_id_date {
    primary_key: yes
    sql: CONCAT(${TABLE}.client_id, ${TABLE}.submission_date) ;;
    type: string
  }

  dimension: is_opt_in {
    type: number
    sql: ${android_clients.is_opt_in} ;;
  }

  dimension: is_surface_expand_settings {
    sql: ${TABLE}.is_surface_expand_settings ;;
    type: number
    hidden: yes
  }

  dimension: is_surface_learn_more_clicked {
    sql: ${TABLE}.is_surface_learn_more_clicked ;;
    type: number
    hidden: yes
  }

  dimension: is_surface_show_privacy_policy_clicked {
    sql: ${TABLE}.is_surface_show_privacy_policy_clicked ;;
    type: number
    hidden: yes
  }

  dimension: is_surface_show_quality_explainer_url_clicked {
    sql: ${TABLE}.is_surface_show_quality_explainer_url_clicked ;;
    type: number
    hidden: yes
  }

  dimension: is_surface_show_terms_clicked {
    sql: ${TABLE}.is_surface_show_terms_clicked ;;
    type: number
    hidden: yes
  }

  #measures

  measure: client_count {
    type: count_distinct
    sql: ${client_id} ;;
  }

  measure: address_bar_feature_callout_displayed_sum {
    sql: ${is_address_bar_feature_callout_displayed} ;;
    type: sum
  }

  measure: address_bar_icon_clicked_sum {
    sql: ${is_address_bar_icon_clicked} ;;
    type: sum
  }

  measure: address_bar_icon_displayed_sum {
    sql: ${is_address_bar_icon_displayed} ;;
    type: sum
  }

  measure: engaged_with_sidebar_sum {
    sql: ${is_engaged_with_sidebar} ;;
    type: sum
  }

  measure: surface_analyze_reviews_none_available_clicked_sum {
    sql: ${is_surface_analyze_reviews_none_available_clicked} ;;
    type: sum
  }

  measure: surface_closed_sum {
    sql: ${is_surface_closed} ;;
    type: sum
  }

  measure: surface_displayed_sum {
    sql: ${is_surface_displayed} ;;
    type: sum
  }

  measure: surface_expand_settings_sum {
    sql: ${is_surface_expand_settings} ;;
    type: sum
  }

  measure: surface_learn_more_clicked_sum {
    sql: ${is_surface_learn_more_clicked} ;;
    type: sum
  }

  measure: surface_no_review_reliability_available_sum {
    sql: ${is_surface_no_review_reliability_available} ;;
    type: sum
  }

  measure: surface_onboarding_displayed_sum {
    sql: ${is_surface_onboarding_displayed} ;;
    type: sum
  }

  measure: surface_reactivated_button_clicked_sum {
    sql: ${is_surface_reactivated_button_clicked} ;;
    type: sum
  }

  measure: surface_reanalyze_clicked_sum {
    sql: ${is_surface_reanalyze_clicked} ;;
    type: sum
  }

  measure: surface_show_more_recent_reviews_clicked_sum {
    sql: ${is_surface_show_more_recent_reviews_clicked} ;;
    type: sum
  }

  measure: surface_show_privacy_policy_clicked_sum {
    sql: ${is_surface_show_privacy_policy_clicked} ;;
    type: sum
  }

  measure: surface_show_quality_explainer_url_clicked_sum {
    sql: ${is_surface_show_quality_explainer_url_clicked} ;;
    type: sum
  }

  measure: surface_show_terms_clicked_sum {
    sql: ${is_surface_show_terms_clicked} ;;
    type: sum
  }

  measure: surface_opt_in_accepted_sum {
    sql: ${surface_opt_in_accepted} ;;
    type: sum
  }

  measure: opt_in_button_click_rate {
    sql: SAFE_DIVIDE(${surface_opt_in_accepted_sum}, ${surface_onboarding_displayed_sum}) ;;
    type: number
    value_format_name: percent_2

  }



}