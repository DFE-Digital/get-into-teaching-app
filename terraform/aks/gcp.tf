resource "google_service_account" "appender" {
  account_id   = "appender-${var.service_short}-${local.environment}"
  display_name = "Service Account appender to ${var.service_name} in ${local.environment} environment"
}
