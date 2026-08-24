<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.9.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.81.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.4.0 |
| <a name="provider_grafana.cloud"></a> [grafana.cloud](#provider\_grafana.cloud) | 4.41.0 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 639a4f39198027aa12d70db65aaaa585086366db |
| <a name="module_auto_dashboard"></a> [auto\_dashboard](#module\_auto\_dashboard) | ./.terraform/modules/__v4__/grafana_dashboard | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [azuread_application.grafana_infinity](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.grafana_infinity](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.grafana_infinity](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azurerm_key_vault_secret.grafana_infinity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_role_assignment.grafana_infinity_viewer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [grafana_contact_point.idpay_app_alerts](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/contact_point) | resource |
| [grafana_dashboard.aca_container_logs_dashboard](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.aks_container_aggregated_logs_dashboard](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.aks_container_logs_dashboard](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.azure_monitor_grafana](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.costs](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_data_source.infinity](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [grafana_folder.alert_folders](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_folder.costs](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_folder.customfolder](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_folder.team_dashboard_folder](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_folder.teams](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_folder_permission.admin_permission](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder_permission) | resource |
| [grafana_folder_permission.team_role_permissions](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder_permission) | resource |
| [grafana_mute_timing.working_hours](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/mute_timing) | resource |
| [grafana_notification_policy.idpay_app_alerts](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/notification_policy) | resource |
| [grafana_rule_group.idpay_app_alerts](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/rule_group) | resource |
| [grafana_team.team_roles](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/team) | resource |
| [azuread_group.ref_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dashboard_grafana.grafana_managed](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dashboard_grafana) | data source |
| [azurerm_key_vault.core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.key_vault_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.grafana_service_account_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.slack_webhook_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_log_analytics_workspace.law_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_log_analytics_workspace.law_core_itn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_log_analytics_workspace.law_mcshared](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [external_external.validate_grafana_token](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [grafana_data_source.grafana-azure-data-explorer-datasource](https://registry.terraform.io/providers/grafana/grafana/latest/docs/data-sources/data_source) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_idpay_grafana_alert_enabled"></a> [idpay\_grafana\_alert\_enabled](#input\_idpay\_grafana\_alert\_enabled) | Enable Grafana alerting resources for the IDPay app. | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_display_name"></a> [location\_display\_name](#input\_location\_display\_name) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_team_groups"></a> [team\_groups](#input\_team\_groups) | Map of groups per team: each key is the team, value is a map 'group\_name' -> { role, users } | <pre>map(map(object({<br/>    permission = string<br/>  })))</pre> | `{}` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_grafana_token_validation"></a> [grafana\_token\_validation](#output\_grafana\_token\_validation) | n/a |
<!-- END_TF_DOCS -->
