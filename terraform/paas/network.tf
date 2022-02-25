data "cloudfoundry_app" "prometheus" {
    name_or_id = var.paas_monitoring_app
    space      = data.cloudfoundry_space.monitoring.id
}

data "cloudfoundry_app" "monitor_apps" {

  name_or_id = cloudfoundry_app.app_application.id
  space      = data.cloudfoundry_space.space.id

  depends_on = [ cloudfoundry_app.app_application ]
}


resource "cloudfoundry_network_policy" "monitoring-policy-app" {

    policy {
        source_app = data.cloudfoundry_app.prometheus.id
        destination_app = data.cloudfoundry_app.monitor_apps.id
        port = "3000"
        protocol = "tcp"
    }
}
