locals {
  app_registrations_map = {
    for app in var.app_registrations :
    app.name => app
  }
  role_assignments_map = merge(flatten([
    for app in var.app_registrations : [
      for permission in app.permissions : {
        for scope in permission.scopes :
        "${app.name}-${permission.role_definition_name}-${scope}" => {
          app                  = app.name
          scope                = scope
          role_definition_name = permission.role_definition_name
        }
  }]])...)
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
}
resource "azuread_application_federated_identity_credential" "this" {
  for_each              = local.federated_credentials_map
  application_object_id = azuread_application.this[each.value.app].object_id
  display_name          = replace(replace(each.value.subject, "/", "__"), ":", "_") // API is not accepting ":" or "/" replacing with "_" and "__"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com/hmcts"
  subject               = each.value.subject
}
