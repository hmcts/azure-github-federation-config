variable "app_registrations" {
  description = "Settings required to configure App Registration described in README.md"
  type = list(object({
    // name of the app registration (will also be used for service principal)
    name = string
    // optional list of user object IDs to set as owners for both app registration and service principal
    // if omitted, value of `azuread_client_config.current.object_id` will be used instead.
    owners = optional(list(string), [])
    // list of github repository "subjects" as described in https://learn.microsoft.com/en-us/graph/api/application-post-federatedidentitycredentials?view=graph-rest-beta&preserve-view=true&tabs=http#request-body
    //  ex. repo:< Organization/Repository >:environment:< Name >
    //  https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux
    subjects = list(string)
    // list of azure builtin role definitions to be assigned to each of defined scopes.
    permissions = list(object({
      role_definition_name   = string
      scopes                 = list(string)
      condition              = optional(string)
      condition_version      = optional(string)
      allowed_acr_repository = optional(string)
    }))
  }))

  validation {
    condition = alltrue(flatten([
      for app in var.app_registrations : [
        for permission in app.permissions :
        !(permission.condition != null && permission.allowed_acr_repository != null)
      ]
    ]))
    error_message = "Set either condition or allowed_acr_repository for a permission, not both."
  }

  validation {
    condition = alltrue(flatten([
      for app in var.app_registrations : [
        for permission in app.permissions :
        permission.allowed_acr_repository == null || trimspace(permission.allowed_acr_repository) != ""
      ]
    ]))
    error_message = "allowed_acr_repository cannot be empty."
  }

  validation {
    condition = alltrue(flatten([
      for app in var.app_registrations : [
        for permission in app.permissions : [
          for subject in app.subjects :
          !(permission.allowed_acr_repository != null && endswith(subject, ":pull_request"))
        ]
      ]
    ]))
    error_message = "Pull request subjects cannot be granted repository-scoped ACR write permissions. Put pull_request subjects under acr_registrations.readers instead."
  }
}

variable "tenant_id" {
  description = "Azure AD tenant ID to be used by providers"
  type        = string
  default     = null
}
