# azure-github-federation-config

## Purpose

The purpose of this repository is to simplify the creation of new federated identity credentials and app
registrations which allows your GitHub Actions workflows to access resources in Azure,
without needing to store the Azure credentials as long-lived GitHub secrets.

See also:
- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure
- https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure

## What's inside
- YAML file [app-registrations.yaml](app-registrations.yaml) containing configuration of all app_registrations created by this repository
- terraform code to take above YAML file as input variables
- terraform module to create app registrations, service principals, federated identity as well as role assignments

### Limitation

Please be aware that there is a hardcoded limit with Azure App Registrations which we cannot bypass.
A single App Registration can only accomadate 20 federated credentials.

Every line under the `subjects` field will take a federated credential from that limit of 20.

Please account for this when adding a subject to an existing App Registration (below) an ensure the `subjects` is no longer than 20 lines.

If you need more than one subject line and it will run over the 20 limit then its best to create a new App Registration.

For those App Registrations set up for `GitHub Actions` please increment the naming +1 from the previously created App Registration

### Adding new app_registrations/integrations

Edit [app-registrations.yaml](app-registrations.yaml) and add new app registration as in below example:

```YAML
- name: <name for the app registration>
  subjects: # list of github repositories authorised to use this app registration
    - 'repo:<org>/<repo>:ref:refs/heads/master'
    - 'repo:<org>/<repo>:pull_request'
  permissions: # list of azure builtin-roles to assign to each of scopes defined within it.
    - role_definition_name: Reader
      scopes: # list of scopes to assign
        - /subscriptions/<subscription id>
        - /subscriptions/<subscription id>/resourceGroups/<resource group>
        - /subscriptions/<subscription id>/resourceGroups/<resource group>/<resource>
    - role_definition_name: Contributor
      scopes:
        - /subscriptions/<subscription id>
        - /subscriptions/<subscription id>/resourceGroups/<resource group>
        - /subscriptions/<subscription id>/resourceGroups/<resource group>/<resource>
        ...
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## See also:
- https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-azure
- https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure
