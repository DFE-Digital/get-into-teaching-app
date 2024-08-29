variable "app_name" { default = null }

variable "cluster" {
  description = "AKS cluster where this app is deployed. Either 'test' or 'production'"
}
variable "namespace" {
  description = "AKS namespace where this app is deployed"
}
variable "environment" {
  description = "Name of the deployed environment in AKS"
}
variable "azure_credentials_json" {
  default     = null
  description = "JSON containing the service principal authentication key when running in automation"
}
variable "azure_resource_prefix" {
  description = "Standard resource prefix. Usually s189t01 (test) or s189p01 (production)"
}
variable "config_short" {
  description = "Short name of the environment configuration, e.g. dv, st, pd..."
}
variable "service_name" {
  description = "Full name of the service. Lowercase and hyphen separated"
}
variable "service_short" {
  description = "Short name to identify the service. Up to 6 charcters."
}
variable "deploy_azure_backing_services" {
  default     = true
  description = "Deploy real Azure backing services like databases, as opposed to containers inside of AKS"
}
variable "enable_postgres_ssl" {
  default     = true
  description = "Enforce SSL connection from the client side"
}
variable "enable_postgres_backup_storage" {
  default     = false
  description = "Create a storage account to store database dumps"
}
variable "docker_image" {
  description = "Docker image full name to identify it in the registry. Includes docker registry, repository and tag e.g.: ghcr.io/dfe-digital/teacher-pay-calculator:673f6309fd0c907014f44d6732496ecd92a2bcd0"
}
variable "external_url" {
  default     = null
  description = "Healthcheck URL for StatusCake monitoring"
}
variable "statuscake_contact_groups" {
  default     = [185037, 282453]
  description = "ID of the contact group in statuscake web UI"
}
variable "enable_monitoring" {
  default     = false
  description = "Enable monitoring and alerting"
}
variable "pr_number" {
  type    = string
  default = ""
}
# from paas
variable "basic_auth" {
  default = 1
}
variable "asset_hostnames" {
  default = []
}
variable "internet_hostnames" {
  default = []
}
variable "command" {
  type    = list(string)
  default = []
}
variable "replicas" {
  default = 1
  type    = number
}
variable "memory_max" {
  default = "1Gi"
  type    = string
}
variable "azure_maintenance_window" {
  default = null
}
variable "postgres_flexible_server_sku" {
  default = "B_Standard_B1ms"
}
variable "postgres_enable_high_availability" {
  default = false
}
variable "enable_logit" { default = false }
variable "enable_prometheus_monitoring" {
  type    = bool
  default = false
}

variable "sidekiq_memory_max" {
  description = "maximum memory of the sidekiq"
  default     = "1Gi"
}

variable "sidekiq_replicas" {
  description = "number of replicas of the sidekiq"
  default     = 1
}

locals {
  azure_credentials = try(jsondecode(var.azure_credentials_json), null)
  postgres_ssl_mode = var.enable_postgres_ssl ? "require" : "disable"

  gcp_project                = "get-into-teaching"
  gcp_region                 = "europe-west2"
  gcp_project_number         = "574582782335"
  gcp_dataset_name           = replace("${var.service_short}_events_${local.environment}_spike", "-", "_")
  gcp_table_name             = "events"
  gcp_workload_id_pool       = "azure-cip-identity-pool"
  gcp_principal              = "principal://iam.googleapis.com/projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/${local.gcp_workload_id_pool}"
  azure_tenant_id            = "9c7d9dd3-840c-4b3f-818e-552865082e16"
  azure_mi_object_id         = "9d05ace4-549b-40cd-9280-73df80dfc3cb"
  gcp_principal_with_subject = "${local.gcp_principal}/subject/${local.azure_mi_object_id}"
  # gcp_credentials = <<EOT
  # {
  #   "universe_domain": "googleapis.com",
  #   "type": "external_account",
  #   "audience": "//iam.googleapis.com/projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/azure-cip-identity-pool/providers/azure-cip-oidc-provider",
  #   "subject_token_type": "urn:ietf:params:oauth:token-type:jwt",
  #   "token_url": "https://sts.googleapis.com/v1/token",
  #   "credential_source": {
  #       "url": "https://login.microsoftonline.com/${local.azure_tenant_id}/oauth2/v2.0/token"
  #   },
  #   "service_account_impersonation_url": "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.appender.email}:generateAccessToken",
  #   "service_account_impersonation": {
  #       "token_lifetime_seconds": 3600
  #   }
  # }
  # EOT
  gcp_credentials = "{\"universe_domain\":\"googleapis.com\",\"type\":\"external_account\",\"audience\":\"//iam.googleapis.com/projects/${local.gcp_project_number}/locations/global/workloadIdentityPools/azure-cip-identity-pool/providers/azure-cip-oidc-provider\",\"subject_token_type\":\"urn:ietf:params:oauth:token-type:jwt\",\"token_url\":\"https://sts.googleapis.com/v1/token\",\"credential_source\":{\"url\":\"https://login.microsoftonline.com/${local.azure_tenant_id}/oauth2/v2.0/token\"},\"service_account_impersonation_url\":\"https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.appender.email}:generateAccessToken\",\"service_account_impersonation\":{\"token_lifetime_seconds\":3600}}"

}
