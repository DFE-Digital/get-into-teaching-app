resource "azurerm_dns_txt_record" "analytics" {
  count = var.hosted_zone[keys(var.hosted_zone)[0]].environment_short == "pd" ? 1 : 0

  name                = "analytics"
  zone_name           = keys(var.hosted_zone)[0]
  resource_group_name = var.hosted_zone[keys(var.hosted_zone)[0]].resource_group_name
  ttl                 = 300

  record {
    value = "google-site-verification=NQ7Yk0nG_HPg7axHjZSohAMOu7sIH8yW00yNHTB_NdI"
  }
}

resource "azurerm_dns_a_record" "analytics" {
  count = var.hosted_zone[keys(var.hosted_zone)[0]].environment_short == "pd" ? 1 : 0

  name                = "analytics"
  zone_name           = keys(var.hosted_zone)[0]
  resource_group_name = var.hosted_zone[keys(var.hosted_zone)[0]].resource_group_name
  ttl                 = 300
  records             = ["216.239.32.21","216.239.34.21","216.239.36.21","216.239.38.21"]
}

resource "azurerm_dns_aaaa_record" "analytics" {
  count = var.hosted_zone[keys(var.hosted_zone)[0]].environment_short == "pd" ? 1 : 0

  name                = "analytics"
  zone_name           = keys(var.hosted_zone)[0]
  resource_group_name = var.hosted_zone[keys(var.hosted_zone)[0]].resource_group_name
  ttl                 = 300
  records             = ["2001:4860:4802:32::15","2001:4860:4802:34::15","2001:4860:4802:36::15","2001:4860:4802:38::15"]
}
