paas_space                = "get-into-teaching-test"
paas_monitoring_space     = "get-into-teaching-monitoring"
paas_monitoring_app       = "prometheus-prod-get-into-teaching"
paas_app_application_name = "get-into-teaching-app-test"
paas_app_route_name       = "get-into-teaching-app-test"
paas_linked_services      = ["get-into-teaching-test-redis-svc", "get-into-teaching-api-test-pg-common-svc"]
paas_internet_hostnames   = ["staging-getintoteaching"]        # The first item in the list will be used as the Application URL, routes will be created for all items.
paas_asset_hostnames      = ["assets-staging-getintoteaching"] # The first item will be used as Asset Hostname, routes will be created for all items.
alerts                    = {}
azure_key_vault           = "s146t01-kv"
azure_resource_group      = "s146t01-rg"
