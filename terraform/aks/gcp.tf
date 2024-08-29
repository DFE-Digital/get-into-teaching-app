resource "google_service_account" "appender" {
  account_id   = "appender-${var.service_short}-${local.environment}-spike"
  display_name = "Service Account appender to ${var.service_name} in ${local.environment} environment"
}

resource "google_service_account_iam_binding" "appender" {
  service_account_id = google_service_account.appender.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    local.gcp_principal_with_subject
  ]
}

resource "google_bigquery_dataset" "main" {
  dataset_id                  = local.gcp_dataset_name
  location                    = local.gcp_region

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  access {
    role          = "projects/${local.gcp_project}/roles/bigquery_appender_custom"
    user_by_email = google_service_account.appender.email
  }
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = local.gcp_table_name

  time_partitioning {
    type = "DAY"
  }

  # https://github.com/DFE-Digital/dfe-analytics/blob/main/docs/create-events-table.sql
  schema = file("${path.module}/config/events.json")
}
