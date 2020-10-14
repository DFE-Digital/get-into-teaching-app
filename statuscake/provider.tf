provider statuscake {
  username = var.sc_username
  apikey   = var.sc_api_key
}

terraform {
  required_version = ">= 0.13.4"

  required_providers {
    statuscake = {
      source  = "thde/statuscake"
      version = "1.1.3"
    }
  }
}


