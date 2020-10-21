provider "cloudfoundry" {
  api_url  = var.api_url
  user     = var.user
  password = var.password
}

terraform {
  required_version = ">= 0.13.4"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.12.6"
    }
  }
}
