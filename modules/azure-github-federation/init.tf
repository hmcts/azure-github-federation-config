terraform {
  required_version = "1.3.9"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.42.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.59.0"
    }
  }
}
