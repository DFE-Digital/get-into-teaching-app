paas_space                = "get-into-teaching"
paas_monitoring_space     = "get-into-teaching"
paas_monitoring_app       = "prometheus-dev-get-into-teaching"
logging                   = 0
instances                 = 1
alerts                    = {}
azure_key_vault           = "s146d01-kv"
azure_resource_group      = "s146d01-rg"
paas_linked_services      = ["get-into-teaching-dev-redis-svc", "get-into-teaching-app-dev-pg-git-svc"]