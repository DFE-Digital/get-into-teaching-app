
data "cloudfoundry_user_provided_service" "logging" {
  name = var.paas_logging_name
  space = data.cloudfoundry_space.space.id
  count = var.logging 
}
