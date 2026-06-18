<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.33 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.76.0 |
| <a name="provider_github"></a> [github](#provider\_github) | 6.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.env_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_environment_variable.env_variables](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_variable) | resource |
| [github_actions_secret.repository_secrets](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.repository_variables](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_repository.repository_settings](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_environment.env](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_ruleset.develop](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [github_repository_ruleset.uat_and_main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_ruleset) | resource |
| [azurerm_key_vault.cicd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.mdc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.argo_cd_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argo_cd_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.gh_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.sonar_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [github_team.admin](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_cd_server"></a> [argo\_cd\_server](#input\_argo\_cd\_server) | Server of the Argo CD (without https). | `string` | `null` | no |
| <a name="input_cicd_kv_name"></a> [cicd\_kv\_name](#input\_cicd\_kv\_name) | Name of the Key Vault where the CI/CD secrets are stored. | `string` | n/a | yes |
| <a name="input_cicd_kv_rg"></a> [cicd\_kv\_rg](#input\_cicd\_kv\_rg) | Name of the resource group where the CI/CD Key Vault is located. | `string` | n/a | yes |
| <a name="input_datavault_service_url"></a> [datavault\_service\_url](#input\_datavault\_service\_url) | URL of the datavault service. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_mdc_kv_name"></a> [mdc\_kv\_name](#input\_mdc\_kv\_name) | Name of the Key Vault where the mdc secrets are stored. | `string` | n/a | yes |
| <a name="input_mdc_kv_rg"></a> [mdc\_kv\_rg](#input\_mdc\_kv\_rg) | Name of the resource group where the mdc Key Vault is located. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
