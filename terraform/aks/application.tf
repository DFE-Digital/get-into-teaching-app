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

# Run database migrations
# https://guides.rubyonrails.org/active_record_migrations.html#preparing-the-database
# Terraform waits for this to complete before starting web_application and worker_application
resource "kubernetes_job" "migrations" {
  metadata {
    name      = "${var.service_name}-${var.environment}-migrations"
    namespace = var.namespace
  }

  spec {
    template {
      metadata {
        labels = { app = "${var.service_name}-${var.environment}-migrations" }
        annotations = {
          "logit.io/send"        = "true"
          "fluentbit.io/exclude" = "true"
        }
      }

      spec {
        container {
          name    = "migrate"
          image   = var.docker_image
          command = ["bundle"]
          args    = ["exec", "rails", "db:prepare"]

          env_from {
            config_map_ref {
              name = module.application_configuration.kubernetes_config_map_name
            }
          }

          env_from {
            secret_ref {
              name = module.application_configuration.kubernetes_secret_name
            }
          }

          resources {
            requests = {
              cpu    = module.cluster_data.configuration_map.cpu_min
              memory = "1Gi"
            }
            limits = {
              cpu    = 1
              memory = "1Gi"
            }
          }

          security_context {
            allow_privilege_escalation = false

            seccomp_profile {
              type = "RuntimeDefault"
            }

            capabilities {
              drop = ["ALL"]
              add  = ["NET_BIND_SERVICE"]
            }
          }
        }

        restart_policy = "Never"
      }
    }

    backoff_limit = 1
  }

  wait_for_completion = true

  timeouts {
    create = "11m"
    update = "11m"
  }
}

module "web_application" {
  source = "./vendor/modules/aks//aks/application"
  depends_on = [kubernetes_job.migrations]

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

  enable_prometheus_monitoring  = var.enable_prometheus_monitoring
}

module "worker_application" {
  source                     = "./vendor/modules/aks//aks/application"
  depends_on = [kubernetes_job.migrations]

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

  enable_prometheus_monitoring  = var.enable_prometheus_monitoring
}
