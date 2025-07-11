include: "../views/new_retention_view_for_acquisition_funnel.view.lkml"
include: "/shared/views/countries.view.lkml"
include: "//mozilla/fenix/datagroups/funnel_retention_week_4_table_last_updated.datagroup.lkml"


explore: funnel_retention_week_4 {
  label: "Acquisition Funnel for Firefox Android"
  view_name: new_retention_view_for_acquisition_funnel

  sql_always_where: ${period_filtered_measures} in ("this", "last")
                     AND ${install_source} = "com.android.vending"
                    AND ${is_mobile}
                    AND ${metric_date} = ${first_seen_date}
                  AND ${new_retention_view_for_acquisition_funnel.app_name} = "Fenix";;

  join: countries {
    type: left_outer
    relationship: one_to_one
    sql_on: ${new_retention_view_for_acquisition_funnel.country} = ${countries.code} ;;
  }

  persist_with: funnel_retention_week_4_table_last_updated
}