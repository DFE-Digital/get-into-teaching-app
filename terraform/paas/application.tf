locals {
  environment_map = { HTTPAUTH_PASSWORD = local.infrastructure_secrets.HTTP-PASSWORD,
    HTTPAUTH_USERNAME = local.infrastructure_secrets.HTTP-USERNAME,
    BASIC_AUTH        = var.basic_auth,
    APP_URL           = length(var.paas_asset_hostnames) == 0 ? "" : "https://${var.paas_internet_hostnames[0]}.${data.cloudfoundry_domain.internet.name}",
  APP_ASSETS_URL = length(var.paas_asset_hostnames) == 0 ? "" : "https://${var.paas_asset_hostnames[0]}.${data.cloudfoundry_domain.internet.name}" }
}


resource "cloudfoundry_app" "app_application" {
  name         = var.paas_app_application_name
  space        = data.cloudfoundry_space.space.id
  docker_image = var.paas_app_docker_image
  stopped      = var.application_stopped
  strategy     = var.strategy
  memory       = 1024
  disk_quota   = 3072
  timeout      = var.timeout
  instances    = var.instances

  dynamic "service_binding" {
    for_each = data.cloudfoundry_user_provided_service.logging
    content {
      service_instance = service_binding.value["id"]
    }
  }

  service_binding {
    service_instance = data.cloudfoundry_service_instance.redis.id
  }

  routes {
    route = cloudfoundry_route.app_route_cloud.id
  }

  routes {
    route = cloudfoundry_route.app_route_internal.id
  }

  dynamic "routes" {
    for_each = data.cloudfoundry_route.app_route_internet
    content {
      route = routes.value["id"]
    }
  }

  dynamic "routes" {
    for_each = data.cloudfoundry_route.app_route_assets
    content {
      route = routes.value["id"]
    }
  }

  environment = { for i, v in merge(local.application_secrets, local.environment_map) : i => v if v != "" }
}
