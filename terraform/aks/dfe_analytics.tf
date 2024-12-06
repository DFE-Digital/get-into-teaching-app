provider "google" {
  project = "get-into-teaching"
}

module "dfe_analytics" {
  count  = var.enable_dfe_analytics_federated_auth ? 1 : 0
  source = "./vendor/modules/aks//aks/dfe_analytics"

  azure_resource_prefix = var.azure_resource_prefix
  cluster               = var.cluster
  namespace             = var.namespace
  service_short         = var.service_short
  environment           = local.environment
  gcp_dataset           = var.dataset_name
  # Required when creating a new dataset
  gcp_keyring           = var.dataset_name == null ? "git-key-ring" : null
  gcp_key               = var.dataset_name == null ? "git-key" : null
  gcp_taxonomy_id       = var.dataset_name == null ? 6582996680844371982 : null
  gcp_policy_tag_id     = var.dataset_name == null ? 2845706316283381915 : null
}