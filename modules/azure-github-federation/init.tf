terraform {
  required_version = "1.3.3"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.28.0"
    }
  }
}
