locals {
  enable_webtest = var.app_webtest_url != null
}

data "azurerm_resource_group" "monitoring" {
  count = local.enable_webtest ? 1 : 0

  name = "${var.azure_resource_prefix}-${var.service_short}-mn-rg"
}

data "azurerm_monitor_action_group" "main" {
  count = local.enable_webtest ? 1 : 0

  name                = "${var.azure_resource_prefix}-${var.service_name}"
  resource_group_name = data.azurerm_resource_group.monitoring[0].name
}

resource "azurerm_log_analytics_workspace" "webtest" {
  count = local.enable_webtest ? 1 : 0

  name                = "${var.azure_resource_prefix}-${var.service_short}-${var.config_short}-ai-log"
  location            = data.azurerm_resource_group.monitoring[0].location
  resource_group_name = data.azurerm_resource_group.monitoring[0].name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_application_insights" "webtest" {
  count = local.enable_webtest ? 1 : 0

  name                = "${var.azure_resource_prefix}-${var.service_short}-${var.config_short}-ai"
  location            = data.azurerm_resource_group.monitoring[0].location
  resource_group_name = data.azurerm_resource_group.monitoring[0].name
  workspace_id        = azurerm_log_analytics_workspace.webtest[0].id
  application_type    = "web"
  retention_in_days   = 30

  internet_ingestion_enabled = false
  internet_query_enabled     = false

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_application_insights_standard_web_test" "webtest" {
  count = local.enable_webtest ? 1 : 0

  name                    = "${var.azure_resource_prefix}-${var.service_short}-${var.config_short}-ai-webtest"
  resource_group_name     = data.azurerm_resource_group.monitoring[0].name
  location                = data.azurerm_resource_group.monitoring[0].location
  application_insights_id = azurerm_application_insights.webtest[0].id
  geo_locations           = ["emea-ru-msa-edge"]
  enabled                 = true

  request {
    url = var.app_webtest_url
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_monitor_metric_alert" "webtest" {
  count = local.enable_webtest ? 1 : 0

  name                = "${var.azure_resource_prefix}-${var.service_short}-${var.config_short}-ai-webtest-alert"
  resource_group_name = data.azurerm_resource_group.monitoring[0].name
  scopes              = [azurerm_application_insights.webtest[0].id]
  description         = "Action will be triggered when web test fails"

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "availabilityResults/availabilityPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.main[0].id
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
