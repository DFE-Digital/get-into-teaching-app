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
    confirmations = 1
    custom_header = "{\"Content-Type\": \"application/x-www-form-urlencoded\"}"
    status_codes  = "204, 205, 206, 303, 400, 401, 403, 404, 405, 406, 408, 410, 413, 444, 429, 494, 495, 496, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 521, 522, 523, 524, 520, 598, 599"

  }	
}
