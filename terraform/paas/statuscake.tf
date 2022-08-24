resource "statuscake_uptime_check" "alert" {
  for_each = var.alerts

  name           = each.value.website_name
  check_interval = each.value.check_rate
  contact_groups = each.value.contact_group
  confirmation   = 2
  trigger_rate   = 0
  regions        = ["london", "dublin"]
  tags           = ["GIT", "BETA"]

  http_check {
    follow_redirects = true
    timeout          = 40
    request_method   = "HTTP"
    status_codes = [
      "204",
      "205",
      "206",
      "303",
      "400",
      "401",
      "403",
      "404",
      "405",
      "406",
      "408",
      "410",
      "413",
      "444",
      "429",
      "494",
      "495",
      "496",
      "499",
      "500",
      "501",
      "502",
      "503",
      "504",
      "505",
      "506",
      "507",
      "508",
      "509",
      "510",
      "511",
      "521",
      "522",
      "523",
      "524",
      "520",
      "598",
      "599"
    ]
    dynamic "basic_authentication" {
      for_each = var.statuscake_enable_basic_auth ? [1] : []
      content {
        username = local.infrastructure_secrets.HTTP-USERNAME
        password = local.infrastructure_secrets.HTTP-PASSWORD
      }
    }
    request_headers = {
      Content-Type = "application/x-www-form-urlencoded"
    }
  }

  monitored_resource {
    address = each.value.website_url
  }
}
