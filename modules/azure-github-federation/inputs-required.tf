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
      role_definition_name = string
      scopes               = list(string)
    }))
  }))
}

variable "tenant_id" {
  description = "Azure AD tenant ID to be used by providers"
  type        = string
  default     = null
}

