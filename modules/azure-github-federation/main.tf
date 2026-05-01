locals {
  app_registrations_map = {
    for app in var.app_registrations :
    app.name => app
  }

  // Helper for Azure ACR repository-scoped ABAC conditions.
  // See https://learn.microsoft.com/en-us/azure/container-registry/container-registry-rbac-abac-repository-permissions
  // The generated condition has two branches: non-repository data actions pass
  // through, while ACR repository read/write data actions must target the
  // repository listed in allowed_acr_repository.
  acr_repository_condition_template = <<-EOT
    (
      (
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/content/read'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/metadata/read'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/content/write'})
        AND
        !(ActionMatches{'Microsoft.ContainerRegistry/registries/repositories/metadata/write'})
      )
      OR
      (
        @Request[Microsoft.ContainerRegistry/registries/repositories:name] StringEqualsIgnoreCase '%s'
      )
    )
  EOT
  role_assignment_values = flatten([
    for app in var.app_registrations : [
      for permission in app.permissions : [
        for scope in permission.scopes : {
          app                  = app.name
          scope                = scope
          role_definition_name = permission.role_definition_name
          condition = permission.condition != null ? permission.condition : (
            permission.allowed_acr_repository == null ? null : trimspace(format(local.acr_repository_condition_template, permission.allowed_acr_repository))
          )
          condition_version = (
            permission.condition != null || permission.allowed_acr_repository != null
          ) ? coalesce(permission.condition_version, "2.0") : null
        }
      ]
    ]
  ])
  role_assignments_map = {
    for role_assignment in local.role_assignment_values :
    "${role_assignment.app}-${role_assignment.role_definition_name}-${role_assignment.scope}${role_assignment.condition == null ? "" : "-${sha1(role_assignment.condition)}"}" => role_assignment
  }
  federated_credentials_map = merge([
    for app in var.app_registrations : {
      for subject in app.subjects :
      "${app.name}-${subject}" => {
        app     = app.name
        subject = subject
      }
  }]...)
}
resource "azuread_application" "this" {
  for_each     = local.app_registrations_map
  display_name = each.value.name
  owners       = length(each.value.owners) == 0 ? [data.azuread_client_config.current.object_id] : concat([data.azuread_client_config.current.object_id], each.value.owners)
}
resource "azuread_service_principal" "this" {
  for_each       = local.app_registrations_map
  application_id = azuread_application.this[each.value.name].application_id
  owners         = length(each.value.owners) == 0 ? [data.azuread_client_config.current.object_id] : concat([data.azuread_client_config.current.object_id], each.value.owners)
}
resource "azurerm_role_assignment" "this" {
  for_each             = local.role_assignments_map
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_service_principal.this[each.value.app].object_id
  condition            = each.value.condition
  condition_version    = each.value.condition_version
}
resource "azuread_application_federated_identity_credential" "this" {
  for_each              = local.federated_credentials_map
  application_object_id = azuread_application.this[each.value.app].object_id
  display_name          = replace(replace(each.value.subject, "/", "__"), ":", "_") // API is not accepting ":" or "/" replacing with "_" and "__"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = each.value.subject
}
