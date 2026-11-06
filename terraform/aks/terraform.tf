terraform {
  required_version = "= 1.14.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.61.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
    statuscake = {
      source  = "StatusCakeDev/statuscake"
      version = "2.2.2"
    }
    airbyte = {
      source  = "airbytehq/airbyte"
      version = "0.10.0"
    }
  }
  backend "azurerm" {
    container_name = "terraform-state"
  }
}

provider "azurerm" {
  features {}

  resource_provider_registrations = "none"
}

provider "kubernetes" {
  host                   = module.cluster_data.kubernetes_host
  cluster_ca_certificate = module.cluster_data.kubernetes_cluster_ca_certificate

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args        = module.cluster_data.kubelogin_args
  }
}

provider "statuscake" {
  api_token = module.infrastructure_secrets.map.SC-PASSWORD
}

provider "airbyte" {
  server_url    = var.airbyte_enabled ? "${local.airbyte_server_url}/api/public/v1" : ""
  client_id     = var.airbyte_enabled ? module.infrastructure_secrets.map.AIRBYTE-CLIENT-ID : ""
  client_secret = var.airbyte_enabled ? module.infrastructure_secrets.map.AIRBYTE-CLIENT-SECRET : ""
}
