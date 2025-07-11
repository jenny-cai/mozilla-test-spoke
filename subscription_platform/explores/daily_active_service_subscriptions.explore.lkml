include: "../views/daily_active_service_subscriptions.view.lkml"
include: "../views/service_subscriptions.view.lkml"
include: "../views/table_metadata.view.lkml"
include: "/shared/views/countries.view.lkml"
include: "/mozilla_vpn/views/vat_rates.view.lkml"
include: "//mozilla/mozilla_vpn/views/exchange_rates_table.view.lkml"

explore: daily_active_service_subscriptions {
  join: countries {
    sql_on: ${daily_active_service_subscriptions.subscription__country_code} = ${countries.code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: current_subscription_state {
    from: service_subscriptions
    sql_on: ${daily_active_service_subscriptions.subscription__id} = ${current_subscription_state.id} ;;
    type: left_outer
    relationship: many_to_one
    fields: [
      is_trial,
      is_active,
      auto_renew,
      has_refunds,
      has_fraudulent_charges
    ]
  }

  join: subscription_other_services {
    from: daily_active_service_subscriptions__subscription__other_services
    # This should use a dimension reference, but Looker currently has a problem resolving dimension references in `sql_table_name`.
    sql_table_name: UNNEST(daily_active_service_subscriptions.subscription.other_services) ;;
    sql_on: TRUE ;;
    type: left_outer
    relationship: one_to_many
  }

  join: table_metadata {
    sql_on: ${table_metadata.table_name} = 'daily_active_service_subscriptions_v1' ;;
    type: left_outer
    relationship: many_to_one
  }

  join: vat_rates {
    view_label: "VAT Rates"
    sql_on:
      ${daily_active_service_subscriptions.subscription__country_code} = ${vat_rates.country_code}
      AND (
        ${daily_active_service_subscriptions.date_raw} BETWEEN ${vat_rates.effective_date} AND ${vat_rates.next_effective_date} - 1
        OR (${daily_active_service_subscriptions.date_raw} >= ${vat_rates.effective_date} AND ${vat_rates.next_effective_date} IS NULL)
      ) ;;
    type: left_outer
    relationship: many_to_one
    fields: [
      vat
    ]
  }

  join: exchange_rates_table {
    view_label: "Exchange Rates"
    sql_on:
      ${daily_active_service_subscriptions.subscription__plan_currency} = ${exchange_rates_table.base_currency}
      AND ${exchange_rates_table.quote_currency} = 'USD'
      AND ${daily_active_service_subscriptions.date_raw} = ${exchange_rates_table.date_raw} ;;
    type: left_outer
    relationship: many_to_one
    fields: [
      price
    ]
  }
}