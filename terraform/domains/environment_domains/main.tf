# Used to create domains to be managed by front door.
module "domains" {
  for_each            = var.hosted_zone
  source              = "./vendor/modules/domains//domains/environment_domains"
  zone                = each.key
  front_door_name     = each.value.front_door_name
  resource_group_name = each.value.resource_group_name
  domains             = each.value.domains
  environment         = each.value.environment_short
  host_name           = try(each.value.origin_hostname, "not-in-use.education.gov.uk")
  null_host_header    = try(each.value.null_host_header, false)
  cached_paths        = try(each.value.cached_paths, [])
  redirect_rules      = try(each.value.redirect_rules, [])
  rate_limit          = try(var.rate_limit, null)
}

# Takes values from hosted_zone.domain_name.cnames (or txt_records, a-records). Use for domains which are not associated with front door.
module "dns_records" {
  source      = "./vendor/modules/domains//dns/records"
  hosted_zone = var.hosted_zone
}
