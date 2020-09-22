
data "cloudfoundry_user_provided_service" "logging" {
  name = var.paas_logging_name
  space = data.cloudfoundry_space.space.id
  count = var.logging 
}

data "cloudfoundry_service_instance" "redis" {
  name_or_id = var.paas_redis_1_name
  space = data.cloudfoundry_space.space.id
}
