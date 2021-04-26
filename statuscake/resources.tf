resource statuscake_test alert {
  for_each =  var.alerts
    
  website_name  = each.value.website_name
  website_url   = each.value.website_url
  test_type     = each.value.test_type
  check_rate    = each.value.check_rate
  contact_group = each.value.contact_group
  trigger_rate  = each.value.trigger_rate
  custom_header = each.value.custom_header
  status_codes  = each.value.status_codes
  basic_user    = var.HTTPAUTH_USERNAME
  basic_pass    = var.HTTPAUTH_PASSWORD
}
