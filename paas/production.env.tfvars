paas_space                 = "get-into-teaching-production"
paas_app_route_name        = "get-into-teaching-app-prod"
paas_app_application_name  = "get-into-teaching-app-prod"
paas_redis_1_name          = "get-into-teaching-prod-redis-svc"
paas_additional_route_name = "beta-getintoteaching"
instances                  = 2

alerts = {
  GiT_App_Production_Healthcheck = {
    website_name  = "Get Into Teaching Website (Production)"
    website_url   = "https://beta-getintoteaching.education.gov.uk/healthcheck.json"
    test_type     = "HTTP"
    check_rate    = 60
    contact_group = [185037]
    trigger_rate  = 0
    custom_header = "{\"Content-Type\": \"application/x-www-form-urlencoded\"}"
  }
}
