output "app_registrations" {
  value = {
    for app in azuread_application.default : app.display_name => {
      id               = app.id
      application_id   = app.application_id
      object_id        = app.object_id
      display_name     = app.display_name
      publisher_domain = app.publisher_domain
      owners           = app.owners
      service_principal = {
        id                    = azuread_service_principal.default[app.display_name].id
        application_id        = azuread_service_principal.default[app.display_name].application_id
        object_id             = azuread_service_principal.default[app.display_name].object_id
        application_tenant_id = azuread_service_principal.default[app.display_name].application_tenant_id
      }
    }
  }
}
