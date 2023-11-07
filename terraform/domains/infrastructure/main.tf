module "domains_infrastructure" {
  source                 = "./vendor/modules/domains//domains/infrastructure"
  hosted_zone            = var.hosted_zone
  deploy_default_records = var.deploy_default_records
}

module "dns" {
  source      = "./vendor/modules/domains//dns/zones"
  hosted_zone = var.hosted_zone_without_front_door
}
