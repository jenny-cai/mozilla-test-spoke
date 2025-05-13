include: "../views/ios_default_browser_metrics.view.lkml"
# include: "//mozilla/firefox_ios/datagroups/metrics_last_updated.datagroup.lkml"

explore: ios_default_browser_metrics {
  label: "Default Browser Metric for iOS"
  view_name: ios_default_browser_metrics
  persist_with: metrics_last_updated
}