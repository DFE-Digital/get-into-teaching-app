resource "google_service_account" "appender" {
  account_id   = "appender-${var.service_short}-${local.environment}-spike"
  display_name = "Service Account appender to ${var.service_name} in ${local.environment} environment"
}

resource "google_bigquery_dataset" "main" {
  dataset_id                  = local.gcp_dataset_name
  location                    = local.gcp_region

  access {
    role          = "projects/${local.gcp_project}/roles/bigquery_appender_custom"
    user_by_email = google_service_account.appender.email
  }
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = "events"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "permalink",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "The Permalink"
  },
  {
    "name": "state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State where the head office is located"
  }
]
EOF

}
