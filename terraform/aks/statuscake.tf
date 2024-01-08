# Commenting out this module as currently statuscake monitoring for git fails due to a large HTTP header.
# We will use an App Insights web test monitor until the dev team can decrease the size of the CSP header.
#
module "statuscake" {
  count = var.enable_monitoring ? 1 : 0

  source = "./vendor/modules/aks//monitoring/statuscake"

  uptime_urls = compact([var.external_url])
  ssl_urls    = compact([var.external_url])

  contact_groups = var.statuscake_contact_groups
}
