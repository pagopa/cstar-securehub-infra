<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.114 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.15 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.32 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.114.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | 61c6484f85d6b260e9d01769ace7efc21d357a10 |
| <a name="module_postgres_flexible_snet"></a> [postgres\_flexible\_snet](#module\_postgres\_flexible\_snet) | ./.terraform/modules/__v3__/subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.postgres](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cidr_user_subnet"></a> [aks\_cidr\_user\_subnet](#input\_aks\_cidr\_user\_subnet) | Aks user network address space. | `list(string)` | n/a | yes |
| <a name="input_artemis_config"></a> [artemis\_config](#input\_artemis\_config) | Aks user network address space. | <pre>object({<br/>    chart_version              = string<br/>    image_repository           = string<br/>    image_tag                  = string<br/>    replica_count              = number<br/>    high_availability          = bool<br/>    persistence                = bool<br/>    storage_class              = string<br/>    access_mode                = string<br/>    storage_size               = string<br/>    management_console_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_cidr_postgres_subnet"></a> [cidr\_postgres\_subnet](#input\_cidr\_postgres\_subnet) | Address prefixes subnet postgres | `list(string)` | `null` | no |
| <a name="input_cosmos_cassandra_account_params"></a> [cosmos\_cassandra\_account\_params](#input\_cosmos\_cassandra\_account\_params) | CosmosDB | <pre>object({<br/>    enabled      = bool<br/>    capabilities = list(string)<br/>    offer_type   = string<br/>    consistency_policy = object({<br/>      consistency_level       = string<br/>      max_interval_in_seconds = number<br/>      max_staleness_prefix    = number<br/>    })<br/>    main_geo_location_zone_redundant = bool<br/>    enable_free_tier                 = bool<br/>    additional_geo_locations = list(object({<br/>      location          = string<br/>      failover_priority = number<br/>      zone_redundant    = bool<br/>    }))<br/>    private_endpoint_enabled          = bool<br/>    public_network_access_enabled     = bool<br/>    is_virtual_network_filter_enabled = bool<br/>    backup_continuous_enabled         = bool<br/>  })</pre> | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_temporal_io_docker_admin_tools_version"></a> [temporal\_io\_docker\_admin\_tools\_version](#input\_temporal\_io\_docker\_admin\_tools\_version) | Temporal admin tools image name & version. You can find it on https://hub.docker.com/r/temporalio/admin-tools/tags. E.g. temporalio/admin-tools:1.25.2-tctl-1.18.1-cli-1.1.1 | `string` | n/a | yes |
| <a name="input_temporal_io_postgres_schema_version"></a> [temporal\_io\_postgres\_schema\_version](#input\_temporal\_io\_postgres\_schema\_version) | Postgres schema version. The schema version can be found here https://github.com/temporalio/temporal/tree/main/schema/postgresql/v12/temporal/versioned | `string` | n/a | yes |
| <a name="input_temporal_pgflex_params"></a> [temporal\_pgflex\_params](#input\_temporal\_pgflex\_params) | Postgres Flexible | <pre>object({<br/>    enabled                                = bool<br/>    sku_name                               = string<br/>    db_version                             = string<br/>    storage_mb                             = string<br/>    zone                                   = number<br/>    standby_zone                           = optional(number, 1)<br/>    backup_retention_days                  = number<br/>    geo_redundant_backup_enabled           = bool<br/>    create_mode                            = string<br/>    pgres_flex_private_endpoint_enabled    = bool<br/>    pgres_flex_ha_enabled                  = bool<br/>    pgres_flex_pgbouncer_enabled           = bool<br/>    pgres_flex_diagnostic_settings_enabled = bool<br/>    max_connections                        = number<br/>    pgbouncer_min_pool_size                = number<br/>    pgbouncer_default_pool_size            = number<br/>  })</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
