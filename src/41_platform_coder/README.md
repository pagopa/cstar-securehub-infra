<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.32.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.32.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | ec828d78964ceb919678940efd2c1e0e32116d08 |
| <a name="module_aks_user_keycloak_snet"></a> [aks\_user\_keycloak\_snet](#module\_aks\_user\_keycloak\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_aks_user_node_pool_keycloak"></a> [aks\_user\_node\_pool\_keycloak](#module\_aks\_user\_node\_pool\_keycloak) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | ./.terraform/modules/__v4__/cert_mounter | n/a |
| <a name="module_keycloak_pgflex"></a> [keycloak\_pgflex](#module\_keycloak\_pgflex) | ./.terraform/modules/__v4__/IDH/postgres_flexible_server | n/a |
| <a name="module_tag_config"></a> [tag\_config](#module\_tag\_config) | ../tag_config | n/a |
| <a name="module_workload_identity_configuration_platform_coder_keycloak"></a> [workload\_identity\_configuration\_platform\_coder\_keycloak](#module\_workload\_identity\_configuration\_platform\_coder\_keycloak) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_workload_identity_platform_coder"></a> [workload\_identity\_platform\_coder](#module\_workload\_identity\_platform\_coder) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.keycloak_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_db_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_db_admin_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.terraform_client_secret_for_keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_flexible_server_database.keycloak_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_private_dns_a_record.keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [helm_release.keycloak](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.keycloak-terraform-client-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_pagopa_theme](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_namespace.keycloak](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.keycloak_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.keycloak_db](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [random_password.keycloak_admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.keycloak_db_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.terraform_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_application_insights.app_insights_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.logs_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_nat_gateway.compute_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/nat_gateway) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.postgres_flexible_privatelink](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.core_monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.platform_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.platform_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.data_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_user_node_pool_keycloak"></a> [aks\_user\_node\_pool\_keycloak](#input\_aks\_user\_node\_pool\_keycloak) | n/a | <pre>object({<br/>    idh_resource_tier = string<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>    os_disk_size_gb   = optional(number, null)<br/>    os_disk_type      = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | Kubernetes | `string` | `"~/.kube"` | no |
| <a name="input_keycloak_configuration"></a> [keycloak\_configuration](#input\_keycloak\_configuration) | n/a | <pre>object({<br/>    image_repository                            = string<br/>    image_tag                                   = string<br/>    image_registry                              = string<br/>    chart_version                               = string<br/>    replica_count_min                           = number<br/>    replica_count_max                           = number<br/>    cpu_request                                 = string<br/>    cpu_limit                                   = string<br/>    memory_request                              = string<br/>    memory_limit                                = string<br/>    http_client_connection_ttl_millis           = number<br/>    http_client_connection_max_idle_time_millis = number<br/>  })</pre> | n/a | yes |
| <a name="input_keycloak_pgflex_params"></a> [keycloak\_pgflex\_params](#input\_keycloak\_pgflex\_params) | Postgres Flexible | <pre>object({<br/>    enabled                                = bool<br/>    zone                                   = number<br/>    idh_resource_tier                      = string<br/>    geo_replication_enabled                = bool<br/>    pgres_flex_pgbouncer_enabled           = bool<br/>    pgres_flex_diagnostic_settings_enabled = bool<br/>    auto_grow_enabled                      = bool<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_mcshared_dns_zone_prefix"></a> [mcshared\_dns\_zone\_prefix](#input\_mcshared\_dns\_zone\_prefix) | The dns subdomain for mcshared | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
