# terraform-module-template

<!-- TODO fill in resource name in link to product documentation -->
Terraform module for [Resource name](https://example.com).

## Example

<!-- todo update module name
```hcl
module "todo_resource_name" {
  source = "git@github.com:hmcts/terraform-module-postgresql-flexible?ref=master"
  ...
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.28.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.28.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.24.0 |

## Resources

| Name | Type |
|------|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/2.28.1/docs/resources/application) | resource |
| [azuread_application_federated_identity_credential.this](https://registry.terraform.io/providers/hashicorp/azuread/2.28.1/docs/resources/application_federated_identity_credential) | resource |
| [azuread_service_principal.this](https://registry.terraform.io/providers/hashicorp/azuread/2.28.1/docs/resources/service_principal) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.24.0/docs/resources/role_assignment) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.28.1/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.24.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_registrations"></a> [app\_registrations](#input\_app\_registrations) | Settings required to configure App Registration described in README.md | <pre>list(object({<br>    // name of the app registration (will also be used for service principal)<br>    name = string<br>    // optional list of user object IDs to set as owners for both app registration and service principal<br>    // if omitted, value of `azuread_client_config.current.object_id` will be used instead.<br>    owners = optional(list(string), [])<br>    // list of github repository "subjects" as described in https://learn.microsoft.com/en-us/graph/api/application-post-federatedidentitycredentials?view=graph-rest-beta&preserve-view=true&tabs=http#request-body<br>    //  ex. repo:< Organization/Repository >:environment:< Name ><br>    //  https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux<br>    subjects = list(string)<br>    // list of azure builtin role definitions to be assigned to each of defined scopes.<br>    permissions = list(object({<br>      role_definition_name = string<br>      scopes               = list(string)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_builtFrom"></a> [builtFrom](#input\_builtFrom) | Name of the GitHub repository this application is being built from. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment value. | `string` | `null` | no |
| <a name="input_product"></a> [product](#input\_product) | https://hmcts.github.io/glossary/#product | `string` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure AD tenant ID to be used by providers | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_registrations"></a> [app\_registrations](#output\_app\_registrations) | n/a |
<!-- END_TF_DOCS -->

## Contributing

We use pre-commit hooks for validating the terraform format and maintaining the documentation automatically.
Install it with:

```shell
$ brew install pre-commit terraform-docs
$ pre-commit install
```

If you add a new hook make sure to run it against all files:
```shell
$ pre-commit run --all-files
```
