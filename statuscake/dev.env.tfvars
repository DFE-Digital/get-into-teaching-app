alerts =  {
ftt = {
    website_name = "get-into-teaching (Development)"
    website_url   = "https://get-into-teaching-app-dev.london.cloudapps.digital/healthcheck.json"
    test_type     = "HTTP"
    check_rate    = 300
    contact_group = [185038]
    trigger_rate  = 0
    custom_header = "{\"Content-Type\": \"application/x-www-form-urlencoded\"}"
    status_codes  = "204, 205, 206, 303, 400, 401, 403, 404, 405, 406, 408, 410, 413, 444, 429, 494, 495, 496, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 521, 522, 523, 524, 520, 598, 599"
  }
}
