data "cloudfoundry_service" "postgres" {
  name = "postgres"
}

data "cloudfoundry_user_provided_service" "logging" {
  name  = var.paas_logging_name
  space = data.cloudfoundry_space.space.id
  count = var.logging
}

resource "cloudfoundry_service_instance" "app_postgres" {
  count = length(var.paas_linked_services) == 0 ? 1 : 0

  name         = var.paas_app_database_name
  space        = data.cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.postgres.service_plans[var.database_plan]
  json_params  = "{}"
}

data "cloudfoundry_service_instance" "linked" {
  for_each   = toset(var.paas_linked_services)
  name_or_id = each.value
  space      = data.cloudfoundry_space.space.id
}

data "cloudfoundry_service" "redis" {
  name = "redis"
}

resource "cloudfoundry_service_instance" "app_redis" {
  count = length(var.paas_linked_services) == 0 ? 1 : 0

  name         = var.paas_app_redis_name
  space        = data.cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.redis.service_plans[var.paas_app_redis_plan]
  json_params  = "{\"maxmemory_policy\": \"allkeys-lfu\" }"
}
