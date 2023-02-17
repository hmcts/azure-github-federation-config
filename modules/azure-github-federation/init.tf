terraform {
  required_version = "1.3.9"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.31.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.35.0"
    }
  }
}
