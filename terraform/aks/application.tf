locals {
  environment  = "${var.environment}${var.pr_number}"
}

module "application_configuration" {
  source = "./vendor/modules/aks//aks/application_configuration"

  namespace              = var.namespace
  environment            = local.environment
  azure_resource_prefix  = var.azure_resource_prefix
  service_short          = var.service_short
  config_short           = var.config_short
  secret_key_vault_short = "app"

  # Delete for non rails apps
  is_rails_application = true

  config_variables = {
    PGSSLMODE        = local.postgres_ssl_mode
  }
  secret_variables = {
    DATABASE_URL = module.postgres.url
    REDIS_URL    = module.redis-cache.url
# below added from paas config
    HTTPAUTH_PASSWORD = module.infrastructure_secrets.map.HTTP-PASSWORD,
    HTTPAUTH_USERNAME = module.infrastructure_secrets.map.HTTP-USERNAME,
    BASIC_AUTH        = var.basic_auth,
    APP_URL           = length(var.internet_hostnames) == 0 ? "" : "https://${var.internet_hostnames[0]}.education.gov.uk",
#   keeping here as a reminder, but went be set in aks and need to confirm impact
    APP_ASSETS_URL    = length(var.asset_hostnames) == 0 ? "" : "https://${var.asset_hostnames[0]}.education.gov.uk"
  }
}

module "web_application" {
  source = "./vendor/modules/aks//aks/application"

  is_web = true

  namespace    = var.namespace
  environment  = local.environment
  service_name = var.service_name
  probe_path   = "/check"
  command      = var.command
  max_memory   = var.memory_max
  replicas     = var.replicas

  cluster_configuration_map  = module.cluster_data.configuration_map
  kubernetes_config_map_name = module.application_configuration.kubernetes_config_map_name
  kubernetes_secret_name     = module.application_configuration.kubernetes_secret_name

  docker_image = var.docker_image
  enable_logit = var.enable_logit
}
