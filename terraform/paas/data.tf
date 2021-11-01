data "azurerm_key_vault" "vault" {
  name                = var.azure_key_vault
  resource_group_name = var.azure_resource_group
}

data "azurerm_key_vault_secret" "application" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = var.azure_vault_secret
}

data "azurerm_key_vault_secret" "infrastructure" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = "INFRA-KEYS"
}

locals {
  application_secrets    = yamldecode(data.azurerm_key_vault_secret.application.value)
  infrastructure_secrets = yamldecode(data.azurerm_key_vault_secret.infrastructure.value)
}

