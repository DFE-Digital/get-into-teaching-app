data "azurerm_key_vault" "vault" {
  name                = var.azure_key_vault
  resource_group_name = var.azure_resource_group
}

data "azurerm_key_vault_secret" "application" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = var.azure_vault_secret
}

locals {
  application_secrets = yamldecode(data.azurerm_key_vault_secret.application.value)
}

data "azurerm_key_vault_secret" "paas_username" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = "PAAS-USERNAME"
}

data "azurerm_key_vault_secret" "paas_password" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = "PAAS-PASSWORD"
}

data "azurerm_key_vault_secret" "statuscake_username" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = "SC-USERNAME"
}

data "azurerm_key_vault_secret" "statuscake_password" {
  key_vault_id = data.azurerm_key_vault.vault.id
  name         = "SC-PASSWORD"
}

