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

locals {
  app_registration_config = yamldecode(file("${path.module}/../../app-registrations.yaml"))
  acr_registrations       = local.app_registration_config.acr_registrations

  acr_reader_app_registrations = [
    for reader in local.acr_registrations.readers : {
      name     = "DTS Developers GitHub Actions ${reader.name} ACR Puller"
      subjects = reader.subjects
      permissions = [
        {
          role_definition_name = "Container Registry Repository Reader"
          scopes               = [local.acr_registrations.prod_registry_scope]
        }
      ]
    }
  ]

  acr_writer_app_registrations = [
    for writer in local.acr_registrations.writers : {
      name     = "DTS Developers GitHub Actions ${writer.name} ACR Publisher"
      subjects = writer.subjects
      permissions = [
        {
          role_definition_name = "Container Registry Repository Reader"
          scopes               = [local.acr_registrations.prod_registry_scope]
        },
        {
          role_definition_name     = "Container Registry Repository Writer"
          scopes                   = [local.acr_registrations.prod_registry_scope]
          allowed_acr_repositories = writer.repositories
        }
      ]
    }
  ]

  app_registrations = concat(
    local.app_registration_config.app_registrations,
    local.acr_reader_app_registrations,
    local.acr_writer_app_registrations,
  )
}

module "this" {
  source            = "../../modules/azure-github-federation"
  app_registrations = local.app_registrations
}
output "app_registrations" { value = module.this.app_registrations }
