
data "cloudfoundry_user_provided_service" "logging" {
  name  = var.paas_logging_name
  space = data.cloudfoundry_space.space.id
  count = var.logging
}

data "cloudfoundry_service_instance" "linked" {
  for_each   = toset(var.paas_linked_services)
  name_or_id = each.value
  space      = data.cloudfoundry_space.space.id
}
