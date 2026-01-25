terraform {
  required_version = "1.3.9"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.7.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}
