# These settings are for the sandbox and should mainly be overriden by TF_VARS 
# or set with environment variables TF_VAR_xxxx

variable "api_url" {
  default = "https://api.london.cloud.service.gov.uk"
}

variable "AZURE_CREDENTIALS" {}
variable "azure_key_vault" {}
variable "azure_resource_group" {}

variable "application_stopped" {
  default = false
}

variable "timeout" {
  default = 180
}

variable "azure_vault_secret" {
  default = "CONTENT-KEYS"
}

variable "paas_space" {
  default = "sandbox"
}

variable "paas_org_name" {
  default = "dfe"
}

variable "instances" {
  default = 1
}

variable "logging" {
  default = 1
}

variable "basic_auth" {
  default = 1
}

variable "paas_asset_hostnames" {
  default = []
}

variable "paas_internet_hostnames" {
  default = []
}

variable "paas_app_route_name" {}

variable "paas_logging_name" {
  default = "logit-ssl-drain"
}

variable "paas_redis_1_name" {
  default = "get-into-teaching-dev-redis-svc"
}

variable "paas_app_application_name" {
  default = "dfe-teacher-services-app"
}

variable "paas_app_docker_image" {
  default = "dfedigital/get-into-teaching-frontend:latest"
}

variable "strategy" {
  default = "blue-green"
}

variable "alerts" {
  type = map(any)
}

