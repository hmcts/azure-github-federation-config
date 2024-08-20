terraform {
  required_version = "1.9.5"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.42.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.44.1"
    }
  }
}
