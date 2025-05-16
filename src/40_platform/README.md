<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 3.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.28.0 |
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 1f109174227e5fa2831540821dd6c8d045f0e70e |
| <a name="module_auto_dashboard"></a> [auto\_dashboard](#module\_auto\_dashboard) | ./.terraform/modules/__v4__/grafana_dashboard | n/a |
| <a name="module_container_app_private_endpoint_snet"></a> [container\_app\_private\_endpoint\_snet](#module\_container\_app\_private\_endpoint\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_default_resource_groups"></a> [default\_resource\_groups](#module\_default\_resource\_groups) | ./.terraform/modules/__v4__/payments_default_resource_groups | n/a |
| <a name="module_storage_private_endpoint_snet"></a> [storage\_private\_endpoint\_snet](#module\_storage\_private\_endpoint\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_synthetic_monitoring_jobs"></a> [synthetic\_monitoring\_jobs](#module\_synthetic\_monitoring\_jobs) | git::https://github.com/pagopa/terraform-azurerm-v4.git//monitoring_function | fix-monitor-function |
| <a name="module_synthetic_snet"></a> [synthetic\_snet](#module\_synthetic\_snet) | ./.terraform/modules/__v4__/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.monitoring_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_container_app_environment.synthetic_cae](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_app_environment) | resource |
| [azurerm_dashboard_grafana.grafana_managed](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dashboard_grafana) | resource |
| [azurerm_key_vault_secret.grafana_service_account_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_workspace.monitoring_log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.cstar_status](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_private_endpoint.private_endpoint_container_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.synthetic_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.grafana_dashboard_identity_roles](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.grafana_dashboard_roles](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.cicd_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.core_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.email_google_cstar_status](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.email_slack_cstar_status](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.grafana_service_account_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_monitor_action_group.infra_opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [external_external.grafana_generate_service_account](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [external_external.validate_grafana_token](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_subnet_container_app_private_endpoints"></a> [cidr\_subnet\_container\_app\_private\_endpoints](#input\_cidr\_subnet\_container\_app\_private\_endpoints) | Address prefixes subnet for container app private endpoints | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_storage_private_endpoints"></a> [cidr\_subnet\_storage\_private\_endpoints](#input\_cidr\_subnet\_storage\_private\_endpoints) | Address prefixes subnet for storage private endpoints | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_synthetic_cae"></a> [cidr\_subnet\_synthetic\_cae](#input\_cidr\_subnet\_synthetic\_cae) | Address prefixes subnet synthetic | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_display_name"></a> [location\_display\_name](#input\_location\_display\_name) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_monitoring_law_daily_quota_gb"></a> [monitoring\_law\_daily\_quota\_gb](#input\_monitoring\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | n/a | yes |
| <a name="input_monitoring_law_retention_in_days"></a> [monitoring\_law\_retention\_in\_days](#input\_monitoring\_law\_retention\_in\_days) | The workspace data retention in days | `number` | n/a | yes |
| <a name="input_monitoring_law_sku"></a> [monitoring\_law\_sku](#input\_monitoring\_law\_sku) | Sku of the Log Analytics Workspace | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_synthetic_alerts_enabled"></a> [synthetic\_alerts\_enabled](#input\_synthetic\_alerts\_enabled) | (Optional) Enables alerts generated by the synthetic monitoring probe | `bool` | n/a | yes |
| <a name="input_synthetic_domain_idpay_enabled"></a> [synthetic\_domain\_idpay\_enabled](#input\_synthetic\_domain\_idpay\_enabled) | (Optional) Enables the synthetic monitoring for the Idpay | `bool` | n/a | yes |
| <a name="input_synthetic_domain_mc_enabled"></a> [synthetic\_domain\_mc\_enabled](#input\_synthetic\_domain\_mc\_enabled) | (Optional) Enables the synthetic monitoring for the Idpay | `bool` | n/a | yes |
| <a name="input_synthetic_domain_shared_enabled"></a> [synthetic\_domain\_shared\_enabled](#input\_synthetic\_domain\_shared\_enabled) | (Optional) Enables the synthetic monitoring for the Idpay | `bool` | n/a | yes |
| <a name="input_synthetic_domain_tae_enabled"></a> [synthetic\_domain\_tae\_enabled](#input\_synthetic\_domain\_tae\_enabled) | (Optional) Enables the synthetic monitoring for the RTD | `bool` | n/a | yes |
| <a name="input_synthetic_self_alert_enabled"></a> [synthetic\_self\_alert\_enabled](#input\_synthetic\_self\_alert\_enabled) | (Optional) enables the alert on the function itself | `bool` | `true` | no |
| <a name="input_synthetic_storage_account_replication_type"></a> [synthetic\_storage\_account\_replication\_type](#input\_synthetic\_storage\_account\_replication\_type) | (Required) table storage replication type | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_token_validation"></a> [grafana\_token\_validation](#output\_grafana\_token\_validation) | n/a |
<!-- END_TF_DOCS -->
