<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.33 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.11 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_github"></a> [github](#provider\_github) | 6.12.1 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | ac1ff495df50f4c7a1f28ab6e09acf3322a4ebc9 |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ./.terraform/modules/__v4__/key_vault_secrets_query | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [github_actions_environment_secret.env_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.env_variables](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_secret.repository_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.repository_variables](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_dependabot_secret.repository_dependabot_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_secret) | resource |
| [github_repository.repository_settings](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_environment.env](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_ruleset.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_team.admin](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_argo_cd_server"></a> [argo\_cd\_server](#input\_argo\_cd\_server) | Server of the Argo CD (without https). | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_eventhub_namespace_name"></a> [eventhub\_namespace\_name](#input\_eventhub\_namespace\_name) | Name of the Event Hub Namespace used for Kafka connection. | `string` | n/a | yes |
| <a name="input_mdc_kv_name"></a> [mdc\_kv\_name](#input\_mdc\_kv\_name) | Name of the Key Vault where the mdc secrets are stored. | `string` | n/a | yes |
| <a name="input_mdc_kv_rg"></a> [mdc\_kv\_rg](#input\_mdc\_kv\_rg) | Name of the resource group where the mdc Key Vault is located. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
