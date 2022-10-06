terraform {
  required_version = "1.3.1"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.28.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}
