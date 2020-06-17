resource "cloudfoundry_route" "app_route_internal" {
    domain = data.cloudfoundry_domain.cloudapps.id
    hostname =  var.paas_app_route_name
    space = data.cloudfoundry_space.space.id
}

data "cloudfoundry_route" "app_route_internet" {
    count = var.additional_routes
    domain = data.cloudfoundry_domain.internet.id
    hostname = var.paas_additional_route_name
}

