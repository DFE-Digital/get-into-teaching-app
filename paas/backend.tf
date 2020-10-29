terraform {
  backend "azurerm" {
    container_name = "pass-tfstate"
  }
}
