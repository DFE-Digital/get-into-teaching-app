locals {
  environment = "${var.environment}${var.pr_number}"
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
    PGSSLMODE           = local.postgres_ssl_mode
    BIGQUERY_DATASET    = var.dataset_name
    BIGQUERY_PROJECT_ID = "get-into-teaching"
    BIGQUERY_TABLE_NAME = "events"
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
    APP_ASSETS_URL           = length(var.asset_hostnames) == 0 ? "" : "https://${var.asset_hostnames[0]}.education.gov.uk"
    GOOGLE_CLOUD_CREDENTIALS = var.enable_dfe_analytics_federated_auth ? module.dfe_analytics[0].google_cloud_credentials : null
  }
}

# Run database migrations
# https://guides.rubyonrails.org/active_record_migrations.html#preparing-the-database
# Terraform waits for this to complete before starting web_application and worker_application
module "migrations" {
  source = "./vendor/modules/aks//aks/job_configuration"
  depends_on = [module.postgres,module.redis-cache]

  namespace    = var.namespace
  environment  = local.environment
  service_name = var.service_name
  docker_image = var.docker_image
  commands     = ["bundle"]
  arguments    = ["exec", "rails", "db:prepare"]
  job_name     = "migrations"
  enable_logit = var.enable_logit

  config_map_ref = module.application_configuration.kubernetes_config_map_name
  secret_ref     = module.application_configuration.kubernetes_secret_name
  cpu            = module.cluster_data.configuration_map.cpu_min
}

module "web_application" {
  source     = "./vendor/modules/aks//aks/application"
  depends_on = [module.migrations]

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

  enable_prometheus_monitoring = var.enable_prometheus_monitoring

  run_as_non_root = true
}

module "worker_application" {
  source     = "./vendor/modules/aks//aks/application"
  depends_on = [module.migrations]

  name                       = "worker"
  is_web                     = false
  namespace                  = var.namespace
  environment                = local.environment
  service_name               = var.service_name
  cluster_configuration_map  = module.cluster_data.configuration_map
  kubernetes_config_map_name = module.application_configuration.kubernetes_config_map_name
  kubernetes_secret_name     = module.application_configuration.kubernetes_secret_name
  docker_image               = var.docker_image
  command                    = ["/bin/sh", "-c", "bundle exec sidekiq -C config/sidekiq.yml"]
  max_memory                 = var.sidekiq_memory_max
  replicas                   = var.sidekiq_replicas
  enable_logit               = var.enable_logit

  enable_prometheus_monitoring = var.enable_prometheus_monitoring

  enable_gcp_wif = true
  run_as_non_root = true
}
