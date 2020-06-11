
resource "cloudfoundry_user_provided_service" "logging" {
  name = var.paas_logging_name
  space = data.cloudfoundry_space.space.id
  syslog_drain_url = var.paas_logging_endpoint_port 
  count = var.logging 

}
