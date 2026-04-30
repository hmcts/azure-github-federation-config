terraform {
  backend "azurerm" {
    storage_account_name = "c04d27a323c8691e1a263sa"
    container_name       = "subscription-tfstate"
    key                  = "UK South/app-registrations/azure-github-federation-config/prod/app-registrations/terraform.tfstate"
  }
  required_version = "~> 1.14"
}
provider "azuread" {}
provider "azurerm" {
  features {}
}
module "this" {
  source            = "../../modules/azure-github-federation"
  app_registrations = yamldecode(file("${path.module}/../../app-registrations.yaml"))
}
output "app_registrations" { value = module.this.app_registrations }
