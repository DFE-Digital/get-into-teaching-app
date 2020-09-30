resource "cloudfoundry_route" "app_route_cloud" {
    domain = data.cloudfoundry_domain.cloudapps.id
    hostname =  var.paas_app_route_name
    space = data.cloudfoundry_space.space.id
    target {
          app = cloudfoundry_app.app_application.id_bg 
    }

}

resource "cloudfoundry_route" "app_route_internal" {
    domain = data.cloudfoundry_domain.internal.id
    hostname =  "${var.paas_app_route_name}-internal" 
    space = data.cloudfoundry_space.space.id
    target {
          app = cloudfoundry_app.app_application.id_bg 
    } 
}

data "cloudfoundry_route" "app_route_internet" {
    count = var.additional_routes
    domain = data.cloudfoundry_domain.internet.id
    hostname = var.paas_additional_route_name
}
