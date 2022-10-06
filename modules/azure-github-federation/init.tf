terraform {
  required_version = "1.3.1"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.29.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}
provider "azurerm" {
  tenant_id = var.tenant_id
  features {}
}
