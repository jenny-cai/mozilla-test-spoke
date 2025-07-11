include: "//mozilla/monitoring/views/missing_document_namespaces_notes.view.lkml"

view: +missing_document_namespaces_notes {

  # Dimensions
  dimension: bug {
    hidden:  yes
  }

  dimension: bug_link {
    label: "Bug"
    type: string
    sql:
      CASE
        WHEN ${bug} IS NOT null THEN CONCAT("Bug ", SPLIT(${bug}, "=")[OFFSET(1)])
        ELSE ""
      END
      ;;
    link: {
      label: "{% if value != '' %} view on Bugzilla {% endif %}"
      url: "{{ bug }}"
      icon_url: "https://bugzilla.mozilla.org/favicon.ico"
    }
  }
}