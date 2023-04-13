paas_space                = "get-into-teaching-test"
paas_monitoring_space     = "get-into-teaching-monitoring"
paas_monitoring_app       = "prometheus-prod-get-into-teaching"
paas_linked_services      = ["get-into-teaching-test-redis-svc", "get-into-teaching-api-test-pg-common-svc"]
paas_app_application_name = "get-into-teaching-app-ur"
paas_app_route_name       = "get-into-teaching-app-ur"
logging                   = 0
instances                 = 1
basic_auth                = 0
alerts                    = {}
azure_key_vault           = "s146t01-kv"
azure_resource_group      = "s146t01-rg"

