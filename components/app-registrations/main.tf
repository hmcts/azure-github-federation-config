terraform {
  backend "azurerm" {}
}

module "this" {
  source            = "../../modules/azure-github-federation"
  app_registrations = yamldecode(file("${path.module}/../../app-registrations.yaml"))
}
output "app_registrations" { value = module.this.app_registrations }
