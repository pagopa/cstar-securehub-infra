<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | ~> 7.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.3.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 4.25 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | 7.6.1 |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.3.0 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 704c2bf399a3e3e8d1e7c61d2e8db51623836dc7 |
| <a name="module_event_hub_idpay_00_configuration"></a> [event\_hub\_idpay\_00\_configuration](#module\_event\_hub\_idpay\_00\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_01_configuration"></a> [event\_hub\_idpay\_01\_configuration](#module\_event\_hub\_idpay\_01\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_eventhub_namespace_idpay_00"></a> [eventhub\_namespace\_idpay\_00](#module\_eventhub\_namespace\_idpay\_00) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_idpay_01"></a> [eventhub\_namespace\_idpay\_01](#module\_eventhub\_namespace\_idpay\_01) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_idpay_audit_storage"></a> [idpay\_audit\_storage](#module\_idpay\_audit\_storage) | ./.terraform/modules/__v4__/storage_account | n/a |
| <a name="module_idpay_cosmos_mongodb_account"></a> [idpay\_cosmos\_mongodb\_account](#module\_idpay\_cosmos\_mongodb\_account) | ./.terraform/modules/__v4__/cosmosdb_account | n/a |
| <a name="module_idpay_cosmosdb_snet"></a> [idpay\_cosmosdb\_snet](#module\_idpay\_cosmosdb\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_idpay_eventhub_snet"></a> [idpay\_eventhub\_snet](#module\_idpay\_eventhub\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_idpay_initiative_storage"></a> [idpay\_initiative\_storage](#module\_idpay\_initiative\_storage) | ./.terraform/modules/__v4__/storage_account | n/a |
| <a name="module_idpay_redis"></a> [idpay\_redis](#module\_idpay\_redis) | ./.terraform/modules/__v4__/redis_cache | n/a |
| <a name="module_idpay_redis_snet"></a> [idpay\_redis\_snet](#module\_idpay\_redis\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_idpay_refund_storage"></a> [idpay\_refund\_storage](#module\_idpay\_refund\_storage) | ./.terraform/modules/__v4__/storage_account | n/a |
| <a name="module_idpay_webview_storage"></a> [idpay\_webview\_storage](#module\_idpay\_webview\_storage) | ./.terraform/modules/__v4__/storage_account | n/a |
| <a name="module_workload_identity"></a> [workload\_identity](#module\_workload\_identity) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |
| <a name="module_workload_identity_configuration"></a> [workload\_identity\_configuration](#module\_workload\_identity\_configuration) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |

## Resources

| Name | Type |
|------|------|
| [argocd_project.domain_project](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/project) | resource |
| [azapi_resource.idpay_audit_log_table](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_cosmosdb_mongo_collection.mongodb_collections_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_eventgrid_system_topic.idpay_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.idpay_refund_storage_topic_event_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_key_vault_secret.argocd_server_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_primary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_secondary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_00_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_01_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.namespace_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.queue_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secrets_redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.webview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_storage_account) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.initiative_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.refund_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.webview_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_servicebus_namespace.idpay_service_bus_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.namespace_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.queues](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.queue_auth_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_storage_container.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_audit_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_webview_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.idpay_audit_legal_hold_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.domain_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argocd_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.servicebus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage_account_blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.idpay_data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.private_endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_spoke_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | (Required) Name of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | (Required) Resource group of the Kubernetes cluster. | `string` | n/a | yes |
| <a name="input_aks_vnet"></a> [aks\_vnet](#input\_aks\_vnet) | n/a | <pre>object({<br/>    name           = string<br/>    resource_group = string<br/>    subnet         = string<br/>  })</pre> | n/a | yes |
| <a name="input_cidr_idpay_data_cosmos"></a> [cidr\_idpay\_data\_cosmos](#input\_cidr\_idpay\_data\_cosmos) | Cosmos subnet network address space. | `list(string)` | `[]` | no |
| <a name="input_cidr_idpay_data_eventhub"></a> [cidr\_idpay\_data\_eventhub](#input\_cidr\_idpay\_data\_eventhub) | Eventhub subnet network address space. | `list(string)` | `[]` | no |
| <a name="input_cidr_idpay_data_redis"></a> [cidr\_idpay\_data\_redis](#input\_cidr\_idpay\_data\_redis) | Redis subnet network address space. | `list(string)` | `[]` | no |
| <a name="input_cidr_idpay_data_servicebus"></a> [cidr\_idpay\_data\_servicebus](#input\_cidr\_idpay\_data\_servicebus) | Servicebus subnet network address space. | `list(string)` | `[]` | no |
| <a name="input_cosmos_mongo_account_params"></a> [cosmos\_mongo\_account\_params](#input\_cosmos\_mongo\_account\_params) | n/a | <pre>object({<br/>    enabled        = bool<br/>    capabilities   = list(string)<br/>    offer_type     = string<br/>    server_version = string<br/>    consistency_policy = object({<br/>      consistency_level       = string<br/>      max_interval_in_seconds = number<br/>      max_staleness_prefix    = number<br/>    })<br/>    main_geo_location_zone_redundant = bool<br/>    enable_free_tier                 = bool<br/>    additional_geo_locations = list(object({<br/>      location          = string<br/>      failover_priority = number<br/>      zone_redundant    = bool<br/>    }))<br/>    private_endpoint_enabled          = bool<br/>    public_network_access_enabled     = bool<br/>    is_virtual_network_filter_enabled = bool<br/>    backup_continuous_enabled         = bool<br/>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_idpay_params"></a> [cosmos\_mongo\_db\_idpay\_params](#input\_cosmos\_mongo\_db\_idpay\_params) | n/a | <pre>object({<br/>    throughput     = number<br/>    max_throughput = number<br/>  })</pre> | n/a | yes |
| <a name="input_dns_default_ttl_sec"></a> [dns\_default\_ttl\_sec](#input\_dns\_default\_ttl\_sec) | Dns records ttl value. | `number` | `3600` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | `"cstar"` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | `true` | no |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | `false` | no |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | `null` | no |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | `null` | no |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br/>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br/>    aggregation = string<br/>    metric_name = string<br/>    description = string<br/>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br/>    operator  = string<br/>    threshold = number<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br/>    frequency = string<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br/>    window_size = string<br/><br/>    dimension = list(object(<br/>      {<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      }<br/>    ))<br/>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | `"Basic"` | no |
| <a name="input_ehns_zone_redundant"></a> [ehns\_zone\_redundant](#input\_ehns\_zone\_redundant) | Specifies if the EventHub Namespace should be Zone Redundant (created across Availability Zones). | `bool` | `false` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br/>    idpay = object({<br/>      eventhub_idpay_00 = bool<br/>      eventhub_idpay_01 = bool<br/>    })<br/>  })</pre> | <pre>{<br/>  "idpay": {<br/>    "eventhub_idpay_00": false,<br/>    "eventhub_idpay_01": false<br/>  }<br/>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_eventhubs_idpay"></a> [eventhubs\_idpay](#input\_eventhubs\_idpay) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br/>    name              = string<br/>    partitions        = number<br/>    message_retention = number<br/>    consumers         = list(string)<br/>    keys = list(object({<br/>      name   = string<br/>      listen = bool<br/>      send   = bool<br/>      manage = bool<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_eventhubs_idpay_01"></a> [eventhubs\_idpay\_01](#input\_eventhubs\_idpay\_01) | A list of event hubs to add to namespace for IDPAY application. | <pre>list(object({<br/>    name              = string<br/>    partitions        = number<br/>    message_retention = number<br/>    consumers         = list(string)<br/>    keys = list(object({<br/>      name   = string<br/>      listen = bool<br/>      send   = bool<br/>      manage = bool<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | `"pagopa.it"` | no |
| <a name="input_idpay_cdn_sa_advanced_threat_protection_enabled"></a> [idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled](#input\_idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_idpay_cdn_storage_account_replication_type"></a> [idpay\_cdn\_storage\_account\_replication\_type](#input\_idpay\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_ns_dns_records_welfare"></a> [ns\_dns\_records\_welfare](#input\_ns\_dns\_records\_welfare) | ns records to delegate the dns zone into the subscription/env. | <pre>list(object({<br/>    name    = string<br/>    records = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_redis_params"></a> [redis\_params](#input\_redis\_params) | Redis configuration parameters | <pre>object({<br/>    capacity = number<br/>    family   = string<br/>    sku_name = string<br/>  })</pre> | n/a | yes |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | `[]` | no |
| <a name="input_rtd_keyvault"></a> [rtd\_keyvault](#input\_rtd\_keyvault) |  | <pre>object({<br/>    name           = string<br/>    resource_group = string<br/>  })</pre> | n/a | yes |
| <a name="input_selfcare_welfare_cdn_storage_account_replication_type"></a> [selfcare\_welfare\_cdn\_storage\_account\_replication\_type](#input\_selfcare\_welfare\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_service_bus_namespace"></a> [service\_bus\_namespace](#input\_service\_bus\_namespace) | n/a | <pre>object({<br/>    sku = string<br/>  })</pre> | n/a | yes |
| <a name="input_spa"></a> [spa](#input\_spa) | spa root dirs | `list(string)` | <pre>[<br/>  "portale-enti",<br/>  "portale-esercenti",<br/>  "mocks/merchant",<br/>  "ricevute"<br/>]</pre> | no |
| <a name="input_storage_account_settings"></a> [storage\_account\_settings](#input\_storage\_account\_settings) | n/a | <pre>object({<br/>    replication_type                   = string<br/>    delete_retention_days              = number<br/>    enable_versioning                  = bool<br/>    advanced_threat_protection_enabled = bool<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
