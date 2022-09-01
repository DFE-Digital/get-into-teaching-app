provider "cloudfoundry" {
  api_url  = var.api_url
  user     = local.infrastructure_secrets.PAAS-USERNAME
  password = local.infrastructure_secrets.PAAS-PASSWORD
}

provider "statuscake" {
  api_token = local.infrastructure_secrets.SC-PASSWORD
}

locals {
  azure_credentials = jsondecode(var.AZURE_CREDENTIALS)
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
  subscription_id = try(local.azure_credentials.subscriptionId, null)
  client_id       = try(local.azure_credentials.clientId, null)
  client_secret   = try(local.azure_credentials.clientSecret, null)
  tenant_id       = try(local.azure_credentials.tenantId, null)
}

terraform {
  required_version = "1.2.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.15.5"
    }
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "2.0.3"
    }
  }
}
