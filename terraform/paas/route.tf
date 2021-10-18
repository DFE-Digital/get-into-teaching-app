data "cloudfoundry_route" "app_route_internet" {
  for_each = toset(var.paas_internet_hostnames)
  hostname = each.value
  domain   = data.cloudfoundry_domain.internet.id
}

data "cloudfoundry_route" "app_route_assets" {
  for_each = toset(var.paas_asset_hostnames)
  hostname = each.value
  domain   = data.cloudfoundry_domain.internet.id
}

resource "cloudfoundry_route" "app_route_cloud" {
  domain   = data.cloudfoundry_domain.cloudapps.id
  hostname = var.paas_app_route_name
  space    = data.cloudfoundry_space.space.id
}

resource "cloudfoundry_route" "app_route_internal" {
  domain   = data.cloudfoundry_domain.internal.id
  hostname = "${var.paas_app_route_name}-internal"
  space    = data.cloudfoundry_space.space.id
}

