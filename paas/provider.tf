provider "cloudfoundry" {
  api_url  = var.api_url
  user     = var.user
  password = var.password
}

provider statuscake {
  username = var.sc_username
  apikey   = var.sc_api_key
}


terraform {
  required_version = ">= 0.13.4"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.12.6"
    }
    statuscake = {
      source  = "thde/statuscake"
      version = "1.1.3"
    }
  }
}
