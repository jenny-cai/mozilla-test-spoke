connection: "bigquery"
label: "Firefox Accounts"
# include: "//mozilla/firefox_accounts/views/fxa_first_seen_table.view.lkml"
# include: "//mozilla/firefox_accounts/explores/*"
include: "views/all_events.view.lkml"
include: "views/auth_events.view.lkml"
include: "views/events.view.lkml"
include: "views/growth_accounting.view.lkml"
include: "explores/*"


explore: +growth_accounting {
  description: "Weekly growth numbers for Firefox Accounts."
  join: fxa_first_seen_table {
    fields: []
    relationship: many_to_one
    sql_on: ${growth_accounting.user_id_sha256} = ${fxa_first_seen_table.user_id} ;;
  }
  always_filter: {
    filters: [growth_accounting.submission_date: "14 days"]
  }
}

explore: +event_counts {
  always_filter: {
    filters: [events.submission_date: "14 days"]
  }
  sql_always_where: timestamp > "2010-01-01" ;;
}