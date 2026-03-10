## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | ~> 7.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.3 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.25 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17 |
| <a name="requirement_keycloak"></a> [keycloak](#requirement\_keycloak) | >= 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | ~> 7.0 |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.3 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.25 |
| <a name="provider_keycloak"></a> [keycloak](#provider\_keycloak) | >= 5.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.36 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 34656073b57f687059ebeeaee7ae9a9616071ae4 |
| <a name="module_aks_idpay_node_pool_blue"></a> [aks\_idpay\_node\_pool\_blue](#module\_aks\_idpay\_node\_pool\_blue) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_aks_idpay_node_pool_green"></a> [aks\_idpay\_node\_pool\_green](#module\_aks\_idpay\_node\_pool\_green) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_aks_overlay_snet"></a> [aks\_overlay\_snet](#module\_aks\_overlay\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_cdn_idpay_assetregister"></a> [cdn\_idpay\_assetregister](#module\_cdn\_idpay\_assetregister) | ./.terraform/modules/__v4__/cdn | n/a |
| <a name="module_cdn_idpay_bonuselettrodomestici"></a> [cdn\_idpay\_bonuselettrodomestici](#module\_cdn\_idpay\_bonuselettrodomestici) | ./.terraform/modules/__v4__/cdn | n/a |
| <a name="module_cdn_idpay_selfcare"></a> [cdn\_idpay\_selfcare](#module\_cdn\_idpay\_selfcare) | ./.terraform/modules/__v4__/cdn | n/a |
| <a name="module_cdn_idpay_welfare"></a> [cdn\_idpay\_welfare](#module\_cdn\_idpay\_welfare) | ./.terraform/modules/__v4__/cdn | n/a |
| <a name="module_cosmos_db_account"></a> [cosmos\_db\_account](#module\_cosmos\_db\_account) | ./.terraform/modules/__v4__/IDH/cosmosdb_account | n/a |
| <a name="module_cosmos_mongodb_collections"></a> [cosmos\_mongodb\_collections](#module\_cosmos\_mongodb\_collections) | git::https://github.com/pagopa/terraform-azurerm-v4.git//cosmosdb_mongodb_collection | a4b4d4eeb688973df4c4f70cb996086497d84bd4 |
| <a name="module_event_hub_idpay_00_configuration"></a> [event\_hub\_idpay\_00\_configuration](#module\_event\_hub\_idpay\_00\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_01_configuration"></a> [event\_hub\_idpay\_01\_configuration](#module\_event\_hub\_idpay\_01\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_02_configuration"></a> [event\_hub\_idpay\_02\_configuration](#module\_event\_hub\_idpay\_02\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_rdb_configuration"></a> [event\_hub\_idpay\_rdb\_configuration](#module\_event\_hub\_idpay\_rdb\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_eventhub_namespace_idpay_00"></a> [eventhub\_namespace\_idpay\_00](#module\_eventhub\_namespace\_idpay\_00) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_idpay_01"></a> [eventhub\_namespace\_idpay\_01](#module\_eventhub\_namespace\_idpay\_01) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_idpay_02"></a> [eventhub\_namespace\_idpay\_02](#module\_eventhub\_namespace\_idpay\_02) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_rdb"></a> [eventhub\_namespace\_rdb](#module\_eventhub\_namespace\_rdb) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_private_endpoint_cosmos_snet"></a> [private\_endpoint\_cosmos\_snet](#module\_private\_endpoint\_cosmos\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_eventhub_snet"></a> [private\_endpoint\_eventhub\_snet](#module\_private\_endpoint\_eventhub\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_redis_snet"></a> [private\_endpoint\_redis\_snet](#module\_private\_endpoint\_redis\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_service_bus_snet"></a> [private\_endpoint\_service\_bus\_snet](#module\_private\_endpoint\_service\_bus\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_storage_snet"></a> [private\_endpoint\_storage\_snet](#module\_private\_endpoint\_storage\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ./.terraform/modules/__v4__/IDH/redis | n/a |
| <a name="module_storage_idpay_asset"></a> [storage\_idpay\_asset](#module\_storage\_idpay\_asset) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_audit"></a> [storage\_idpay\_audit](#module\_storage\_idpay\_audit) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_initiative"></a> [storage\_idpay\_initiative](#module\_storage\_idpay\_initiative) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_refund"></a> [storage\_idpay\_refund](#module\_storage\_idpay\_refund) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_webview"></a> [storage\_idpay\_webview](#module\_storage\_idpay\_webview) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_tag_config"></a> [tag\_config](#module\_tag\_config) | ../../tag_config | n/a |
| <a name="module_workload_identity_configuration_v2"></a> [workload\_identity\_configuration\_v2](#module\_workload\_identity\_configuration\_v2) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_workload_identity_v2"></a> [workload\_identity\_v2](#module\_workload\_identity\_v2) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |

## Resources

| Name | Type |
|------|------|
| [argocd_project.domain_project](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/project) | resource |
| [azapi_resource.idpay_audit_log_table](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_api_management_logger.apim_logger](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_application_insights.idpay_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_cdn_endpoint_custom_domain.bonus_custom_domains](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_endpoint_custom_domain) | resource |
| [azurerm_cosmosdb_mongo_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_dns_a_record.bonus_all_zones_apex](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_a_record) | resource |
| [azurerm_dns_cname_record.bonus_all_zones_cdnverify](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dns_cname_record) | resource |
| [azurerm_eventgrid_system_topic.idpay_asset_register_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic.idpay_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.idpay_asset_register_storage_topic_event_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.idpay_refund_storage_topic_event_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_key_vault_access_policy.cdn_certificates_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.appinisights_connection_string_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.argocd_server_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.asset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_primary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_secondary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_00_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_01_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_02_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_rdb_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_welfare_cdn_storage_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_url_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.namespace_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.queue_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secrets_redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.webview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_storage_account) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_data_collection_endpoint.idpay_audit_dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.idpay_audit_dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.idpay_audit_dce_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_monitor_data_collection_rule_association.idpay_audit_dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_private_dns_a_record.ingress_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_resource_group.idpay_monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.asset_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_asset_register_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.initiative_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.refund_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.webview_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_servicebus_namespace.idpay_service_bus_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.namespace_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.queues](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.queue_auth_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_storage_blob.oidc_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_asset_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_audit_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_webview_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [keycloak_openid_client.merchant_operator_frontend](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client.user_frontend](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_realm.merchant_operator](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm) | resource |
| [keycloak_realm.user](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.idpay_audit_legal_hold_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.microsoft_cdn](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.core_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.bonus_elettrodomestici_apex](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_dns_zone.public_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_key_vault.core_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_certificate.bonus_elettrodomestici_cert_apex](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |
| [azurerm_key_vault_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argocd_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.keycloak_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.keycloak_url_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_from_address](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.terraform_client_secret_for_keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.core_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_nat_gateway.compute_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/nat_gateway) | data source |
| [azurerm_private_dns_zone.blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.servicebus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.core_monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.idpay_data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.idpay_monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resources.aks_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_spoke_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_nodepool_blue"></a> [aks\_nodepool\_blue](#input\_aks\_nodepool\_blue) | Paramters for blue node pool | <pre>object({<br/>    vm_sku_name       = string<br/>    autoscale_enabled = optional(bool, true)<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>  })</pre> | n/a | yes |
| <a name="input_aks_nodepool_green"></a> [aks\_nodepool\_green](#input\_aks\_nodepool\_green) | Paramters for blue node pool | <pre>object({<br/>    vm_sku_name       = string<br/>    autoscale_enabled = optional(bool, true)<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_idpay_params"></a> [cosmos\_mongo\_db\_idpay\_params](#input\_cosmos\_mongo\_db\_idpay\_params) | n/a | <pre>object({<br/>    throughput     = number<br/>    max_throughput = number<br/>  })</pre> | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | n/a | yes |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | n/a | yes |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | `number` | n/a | yes |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | n/a | yes |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br/>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br/>    aggregation = string<br/>    metric_name = string<br/>    description = string<br/>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br/>    operator  = string<br/>    threshold = number<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br/>    frequency = string<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br/>    window_size = string<br/><br/>    dimension = list(object(<br/>      {<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      }<br/>    ))<br/>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br/>    idpay = object({<br/>      eventhub_idpay_00 = bool<br/>      eventhub_idpay_01 = bool<br/>      eventhub_rdb      = bool<br/>    })<br/>  })</pre> | <pre>{<br/>  "idpay": {<br/>    "eventhub_idpay_00": false,<br/>    "eventhub_idpay_01": false,<br/>    "eventhub_rdb": false<br/>  }<br/>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_idpay_cdn_sa_advanced_threat_protection_enabled"></a> [idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled](#input\_idpay\_cdn\_sa\_advanced\_threat\_protection\_enabled) | n/a | `bool` | n/a | yes |
| <a name="input_idpay_cdn_storage_account_replication_type"></a> [idpay\_cdn\_storage\_account\_replication\_type](#input\_idpay\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | AKS | `string` | `"~/.kube"` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_short_weu"></a> [location\_short\_weu](#input\_location\_short\_weu) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_weu"></a> [location\_weu](#input\_location\_weu) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_mcshared_dns_zone_prefix"></a> [mcshared\_dns\_zone\_prefix](#input\_mcshared\_dns\_zone\_prefix) | The dns subdomain for mcshared | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | n/a | yes |
| <a name="input_selfcare_welfare_cdn_storage_account_replication_type"></a> [selfcare\_welfare\_cdn\_storage\_account\_replication\_type](#input\_selfcare\_welfare\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_service_bus_namespace"></a> [service\_bus\_namespace](#input\_service\_bus\_namespace) | n/a | <pre>object({<br/>    sku                          = string<br/>    capacity                     = optional(number, 0)<br/>    premium_messaging_partitions = optional(number, 0)<br/>  })</pre> | n/a | yes |
| <a name="input_single_page_applications_asset_register_roots_dirs"></a> [single\_page\_applications\_asset\_register\_roots\_dirs](#input\_single\_page\_applications\_asset\_register\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |
| <a name="input_single_page_applications_portal_merchants_operator_roots_dirs"></a> [single\_page\_applications\_portal\_merchants\_operator\_roots\_dirs](#input\_single\_page\_applications\_portal\_merchants\_operator\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |
| <a name="input_single_page_applications_roots_dirs"></a> [single\_page\_applications\_roots\_dirs](#input\_single\_page\_applications\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_vmss_idpay_ids"></a> [aks\_vmss\_idpay\_ids](#output\_aks\_vmss\_idpay\_ids) | n/a |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | ~> 7.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.6.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.25 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17 |
| <a name="requirement_keycloak"></a> [keycloak](#requirement\_keycloak) | >= 5.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | 7.11.2 |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.6.1 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.6.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.50.0 |
| <a name="provider_keycloak"></a> [keycloak](#provider\_keycloak) | 5.5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | d38fd519025c6f9d0e4119ebc5b5039021afbac4 |
| <a name="module_aks_idpay_node_pool_blue"></a> [aks\_idpay\_node\_pool\_blue](#module\_aks\_idpay\_node\_pool\_blue) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_aks_idpay_node_pool_green"></a> [aks\_idpay\_node\_pool\_green](#module\_aks\_idpay\_node\_pool\_green) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_aks_overlay_snet"></a> [aks\_overlay\_snet](#module\_aks\_overlay\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_cdn_idpay_assetregister"></a> [cdn\_idpay\_assetregister](#module\_cdn\_idpay\_assetregister) | ./.terraform/modules/__v4__/cdn_frontdoor | n/a |
| <a name="module_cdn_idpay_bonuselettrodomestici"></a> [cdn\_idpay\_bonuselettrodomestici](#module\_cdn\_idpay\_bonuselettrodomestici) | ./.terraform/modules/__v4__/cdn_frontdoor | n/a |
| <a name="module_cdn_idpay_welfare"></a> [cdn\_idpay\_welfare](#module\_cdn\_idpay\_welfare) | ./.terraform/modules/__v4__/cdn_frontdoor | n/a |
| <a name="module_cosmos_db_account"></a> [cosmos\_db\_account](#module\_cosmos\_db\_account) | ./.terraform/modules/__v4__/IDH/cosmosdb_account | n/a |
| <a name="module_cosmos_mongodb_collections"></a> [cosmos\_mongodb\_collections](#module\_cosmos\_mongodb\_collections) | ./.terraform/modules/__v4__/cosmosdb_mongodb_collection | n/a |
| <a name="module_event_hub_idpay_00_configuration"></a> [event\_hub\_idpay\_00\_configuration](#module\_event\_hub\_idpay\_00\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_01_configuration"></a> [event\_hub\_idpay\_01\_configuration](#module\_event\_hub\_idpay\_01\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_02_configuration"></a> [event\_hub\_idpay\_02\_configuration](#module\_event\_hub\_idpay\_02\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_event_hub_idpay_rdb_configuration"></a> [event\_hub\_idpay\_rdb\_configuration](#module\_event\_hub\_idpay\_rdb\_configuration) | ./.terraform/modules/__v4__/eventhub_configuration | n/a |
| <a name="module_eventhub_namespace_idpay_00"></a> [eventhub\_namespace\_idpay\_00](#module\_eventhub\_namespace\_idpay\_00) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_idpay_01"></a> [eventhub\_namespace\_idpay\_01](#module\_eventhub\_namespace\_idpay\_01) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_idpay_02"></a> [eventhub\_namespace\_idpay\_02](#module\_eventhub\_namespace\_idpay\_02) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_eventhub_namespace_rdb"></a> [eventhub\_namespace\_rdb](#module\_eventhub\_namespace\_rdb) | ./.terraform/modules/__v4__/eventhub | n/a |
| <a name="module_kubernetes_service_account"></a> [kubernetes\_service\_account](#module\_kubernetes\_service\_account) | ./.terraform/modules/__v4__/kubernetes_service_account | n/a |
| <a name="module_private_endpoint_cosmos_snet"></a> [private\_endpoint\_cosmos\_snet](#module\_private\_endpoint\_cosmos\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_eventhub_snet"></a> [private\_endpoint\_eventhub\_snet](#module\_private\_endpoint\_eventhub\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_redis_snet"></a> [private\_endpoint\_redis\_snet](#module\_private\_endpoint\_redis\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_service_bus_snet"></a> [private\_endpoint\_service\_bus\_snet](#module\_private\_endpoint\_service\_bus\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_private_endpoint_storage_snet"></a> [private\_endpoint\_storage\_snet](#module\_private\_endpoint\_storage\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_redis"></a> [redis](#module\_redis) | ./.terraform/modules/__v4__/IDH/redis | n/a |
| <a name="module_storage_idpay_asset"></a> [storage\_idpay\_asset](#module\_storage\_idpay\_asset) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_audit"></a> [storage\_idpay\_audit](#module\_storage\_idpay\_audit) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_exports"></a> [storage\_idpay\_exports](#module\_storage\_idpay\_exports) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_initiative"></a> [storage\_idpay\_initiative](#module\_storage\_idpay\_initiative) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_refund"></a> [storage\_idpay\_refund](#module\_storage\_idpay\_refund) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_storage_idpay_webview"></a> [storage\_idpay\_webview](#module\_storage\_idpay\_webview) | ./.terraform/modules/__v4__/IDH/storage_account | n/a |
| <a name="module_tag_config"></a> [tag\_config](#module\_tag\_config) | ../../tag_config | n/a |
| <a name="module_workload_identity_configuration_v2"></a> [workload\_identity\_configuration\_v2](#module\_workload\_identity\_configuration\_v2) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_workload_identity_v2"></a> [workload\_identity\_v2](#module\_workload\_identity\_v2) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |

## Resources

| Name | Type |
|------|------|
| [argocd_project.domain_project](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/project) | resource |
| [azapi_resource.create_tables_idpay](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.idpay_audit_log_table](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.approve_pe](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azapi_resource_action.kusto_approve_pe](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_api_management_logger.apim_logger](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_application_insights.idpay_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_cosmosdb_mongo_collection.mongodb_collections_rdb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) | resource |
| [azurerm_cosmosdb_mongo_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_cosmosdb_mongo_database.rdb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) | resource |
| [azurerm_data_factory_custom_dataset.datasets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_custom_dataset) | resource |
| [azurerm_data_factory_data_flow.dataflows](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_data_flow) | resource |
| [azurerm_data_factory_linked_custom_service.adf_cosmosdb_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_custom_service) | resource |
| [azurerm_data_factory_linked_custom_service.bonus_blob_storage_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_custom_service) | resource |
| [azurerm_data_factory_linked_custom_service.idpay_blob_storage_trx_report_linked_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_custom_service) | resource |
| [azurerm_data_factory_linked_custom_service.idpay_exports_blobfs_ls](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_custom_service) | resource |
| [azurerm_data_factory_linked_service_kusto.kusto](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_kusto) | resource |
| [azurerm_data_factory_managed_private_endpoint.adf_cosmosdb_mpe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_managed_private_endpoint) | resource |
| [azurerm_data_factory_managed_private_endpoint.adf_dataexplorer_mpe](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_managed_private_endpoint) | resource |
| [azurerm_data_factory_pipeline.idpay_transaction_report](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.idpay_user_details_report](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_pipeline.pipelines](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline) | resource |
| [azurerm_data_factory_trigger_schedule.daily_triggers_T](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_schedule) | resource |
| [azurerm_data_factory_trigger_schedule.daily_triggers_U](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_schedule) | resource |
| [azurerm_data_factory_trigger_schedule.idpay_copy_rdb_products_to_csv_daily](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_schedule) | resource |
| [azurerm_data_factory_trigger_schedule.weekly_triggers](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_trigger_schedule) | resource |
| [azurerm_eventgrid_system_topic.idpay_asset_register_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic.idpay_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.idpay_asset_register_storage_topic_event_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_eventgrid_system_topic_event_subscription.idpay_refund_storage_topic_event_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventgrid_system_topic_event_subscription) | resource |
| [azurerm_key_vault_access_policy.azdevops_iac_managed_identities_read_only](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.azdevops_iac_managed_identities_write](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_access_policy.kv_policy_adf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_secret.aks_apiserver_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinisights_connection_string_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.argocd_server_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.asset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_cacrt](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.azure_devops_sa_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_primary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.cosmosdb_account_mongodb_secondary_connection_strings](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.data_factory_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.data_factory_rg_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.data_factory_subscription_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.data_factory_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_00_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_01_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_02_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.event_hub_idpay_rdb_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_welfare_cdn_storage_blob_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_welfare_cdn_storage_primary_access_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.idpay_welfare_cdn_storage_primary_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.initiative_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_merchant_operator_app_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_perf_test_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_url_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.namespace_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.queue_auth_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.refund](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secrets_redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.webview](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_kusto_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_database) | resource |
| [azurerm_kusto_database_principal_assignment.adf_mi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_database_principal_assignment) | resource |
| [azurerm_kusto_database_principal_assignment.kusto_ad_groups](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kusto_database_principal_assignment) | resource |
| [azurerm_log_analytics_data_export_rule.idpay_audit_analytics_export_rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |
| [azurerm_log_analytics_linked_storage_account.idpay_audit_analytics_linked_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_linked_storage_account) | resource |
| [azurerm_log_analytics_workspace.log_analytics_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_action_group.idpay_opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_data_collection_endpoint.idpay_audit_dce](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_endpoint) | resource |
| [azurerm_monitor_data_collection_rule.idpay_audit_dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule) | resource |
| [azurerm_monitor_data_collection_rule_association.idpay_audit_dce_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_monitor_data_collection_rule_association.idpay_audit_dcra](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_private_dns_a_record.ingress_idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_endpoint.service_bus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.adf_can_access_exports_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.adf_can_list_service_sas](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.adf_can_read_kv_secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.asset_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_asset_register_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.event_grid_sender_role_on_refund_storage_topic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.initiative_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.refund_service_delegator_role](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.refund_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_blob_storage_refund](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.role_datafactory_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.webview_storage_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_servicebus_namespace.idpay_service_bus_ns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace) | resource |
| [azurerm_servicebus_namespace_authorization_rule.namespace_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace_authorization_rule) | resource |
| [azurerm_servicebus_queue.queues](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue) | resource |
| [azurerm_servicebus_queue_authorization_rule.queue_auth_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_queue_authorization_rule) | resource |
| [azurerm_storage_blob.eie_static_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.pos_static_files](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.selfcare_oidc_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) | resource |
| [azurerm_storage_container.idpay](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_asset_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_audit_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_export_products_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_initiative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_storage_container.idpay_webview_container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [keycloak_attribute_importer_identity_provider_mapper.date_of_birth_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/attribute_importer_identity_provider_mapper) | resource |
| [keycloak_attribute_importer_identity_provider_mapper.first_name_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/attribute_importer_identity_provider_mapper) | resource |
| [keycloak_attribute_importer_identity_provider_mapper.last_name_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/attribute_importer_identity_provider_mapper) | resource |
| [keycloak_attribute_importer_identity_provider_mapper.username_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/attribute_importer_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.domain_admin_realm_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.domain_developers_realm_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.domain_externals_realm_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.strip_tinit_fiscalnumber](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_hardcoded_attribute_identity_provider_mapper.email_importer](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/hardcoded_attribute_identity_provider_mapper) | resource |
| [keycloak_oidc_identity_provider.one_identity_provider](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/oidc_identity_provider) | resource |
| [keycloak_openid_client.merchant_operator_app_client](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client.merchant_operator_frontend](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client.merchant_operator_perf_test](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client.user_frontend](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client.users_operator_perf_test](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client) | resource |
| [keycloak_openid_client_default_scopes.default_scopes_user_frontend](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_default_scopes) | resource |
| [keycloak_openid_client_default_scopes.merchant_frontend_defaults](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_default_scopes) | resource |
| [keycloak_openid_client_default_scopes.merchant_operator_perf_test_defaults](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_default_scopes) | resource |
| [keycloak_openid_client_default_scopes.users_operator_perf_test_defaults](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_default_scopes) | resource |
| [keycloak_openid_client_scope.date_of_birth_scope](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_scope) | resource |
| [keycloak_openid_client_scope.fiscal_number_scope](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_scope) | resource |
| [keycloak_openid_client_scope.merchant_id_scope](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_scope) | resource |
| [keycloak_openid_client_scope.point_of_sale_id_scope](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_scope) | resource |
| [keycloak_openid_client_scope.transaction_permissions_scope](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_scope) | resource |
| [keycloak_openid_client_service_account_role.app_client_service_account_role_manage_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_service_account_role) | resource |
| [keycloak_openid_client_service_account_role.app_client_service_account_role_query_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_service_account_role) | resource |
| [keycloak_openid_client_service_account_role.app_client_service_account_role_view_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_client_service_account_role) | resource |
| [keycloak_openid_hardcoded_claim_protocol_mapper.transaction_permissions_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_hardcoded_claim_protocol_mapper) | resource |
| [keycloak_openid_user_attribute_protocol_mapper.date_of_birth_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_user_attribute_protocol_mapper) | resource |
| [keycloak_openid_user_attribute_protocol_mapper.fiscal_number_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_user_attribute_protocol_mapper) | resource |
| [keycloak_openid_user_attribute_protocol_mapper.merchant_id_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_user_attribute_protocol_mapper) | resource |
| [keycloak_openid_user_attribute_protocol_mapper.point_of_sale_id_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/openid_user_attribute_protocol_mapper) | resource |
| [keycloak_realm.merchant_operator](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm) | resource |
| [keycloak_realm.user](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm) | resource |
| [keycloak_realm_user_profile.merchant_op_profile](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm_user_profile) | resource |
| [keycloak_realm_user_profile.user_profile](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/realm_user_profile) | resource |
| [keycloak_role.domain_admin_role](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/role) | resource |
| [keycloak_role.domain_view_role](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/role) | resource |
| [keycloak_user_template_importer_identity_provider_mapper.userid_template_importer](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/user_template_importer_identity_provider_mapper) | resource |
| [kubernetes_namespace.namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.system_domain_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_role_binding.deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.kube_system_reader_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_role_binding.system_deployer_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [null_resource.idpay_audit_legal_hold_configuration](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.trigger_create_tables_idpay](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_password.keycloak_merchant_operator_app_client](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.keycloak_perf_test_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azapi_resource.cosmos_pe_connection](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/resource) | data source |
| [azapi_resource.privatelink_private_endpoint_connection](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/resource) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_idpay_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_idpay_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_idpay_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_idpay_oncall](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_idpay_project_managers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_api_management.apim_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_application_insights.core_application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_data_factory.data_factory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/data_factory) | data source |
| [azurerm_dns_zone.bonus_elettrodomestici_apex](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_dns_zone.public_cstar](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/dns_zone) | data source |
| [azurerm_key_vault.core_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault.domain_kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argocd_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.keycloak_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.oneidentity-client-id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.oneidentity-client-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.opsgenie-idpay-apy-key-client-secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_from_address](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.ses_smtp_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.terraform_client_secret_for_keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_kusto_cluster.kusto_cluster](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kusto_cluster) | data source |
| [azurerm_log_analytics_workspace.core_log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_nat_gateway.compute_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/nat_gateway) | data source |
| [azurerm_private_dns_zone.blob_storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.cosmos_mongo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.eventhub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.redis](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.service_bus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.storage_account_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.apim_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.core_monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.idpay_data_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.idpay_monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.platform_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resources.aks_vmss](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.iac_federated_azdo](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.vnet_spoke_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [keycloak_openid_client.management_client](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/openid_client) | data source |
| [keycloak_openid_client.realm_mgmt](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/openid_client) | data source |
| [keycloak_role.manage_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.query_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_manage_clients](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_manage_events](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_manage_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_query_clients](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_query_groups](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_query_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_view_clients](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_view_events](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_view_realm](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.user_view_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |
| [keycloak_role.view_users](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/data-sources/role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_geo_locations"></a> [additional\_geo\_locations](#input\_additional\_geo\_locations) | Specifies a list of additional geo\_location resources, used to define where data should be replicated. | <pre>list(object({<br/>    location          = string<br/>    failover_priority = number<br/>    zone_redundant    = bool<br/>  }))</pre> | `[]` | no |
| <a name="input_aks_nodepool_blue"></a> [aks\_nodepool\_blue](#input\_aks\_nodepool\_blue) | Paramters for blue node pool | <pre>object({<br/>    vm_sku_name       = string<br/>    autoscale_enabled = optional(bool, true)<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>  })</pre> | n/a | yes |
| <a name="input_aks_nodepool_green"></a> [aks\_nodepool\_green](#input\_aks\_nodepool\_green) | Paramters for blue node pool | <pre>object({<br/>    vm_sku_name       = string<br/>    autoscale_enabled = optional(bool, true)<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>  })</pre> | n/a | yes |
| <a name="input_cosmos_mongo_db_idpay_params"></a> [cosmos\_mongo\_db\_idpay\_params](#input\_cosmos\_mongo\_db\_idpay\_params) | n/a | <pre>object({<br/>    throughput     = number<br/>    max_throughput = number<br/>  })</pre> | n/a | yes |
| <a name="input_data_factory_api_base_url"></a> [data\_factory\_api\_base\_url](#input\_data\_factory\_api\_base\_url) | Internal API for Data Factory | `string` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_dns_zone_prefix"></a> [dns\_zone\_prefix](#input\_dns\_zone\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_ehns_alerts_enabled"></a> [ehns\_alerts\_enabled](#input\_ehns\_alerts\_enabled) | Event hub alerts enabled? | `bool` | n/a | yes |
| <a name="input_ehns_auto_inflate_enabled"></a> [ehns\_auto\_inflate\_enabled](#input\_ehns\_auto\_inflate\_enabled) | Is Auto Inflate enabled for the EventHub Namespace? | `bool` | n/a | yes |
| <a name="input_ehns_capacity"></a> [ehns\_capacity](#input\_ehns\_capacity) | Specifies the Capacity / Throughput Units for a Standard SKU namespace. | <pre>object({<br/>    ns_00 = number<br/>    ns_01 = number<br/>    ns_02 = number<br/>    rdb   = number<br/>  })</pre> | n/a | yes |
| <a name="input_ehns_maximum_throughput_units"></a> [ehns\_maximum\_throughput\_units](#input\_ehns\_maximum\_throughput\_units) | Specifies the maximum number of throughput units when Auto Inflate is Enabled | `number` | n/a | yes |
| <a name="input_ehns_metric_alerts"></a> [ehns\_metric\_alerts](#input\_ehns\_metric\_alerts) | Map of name = criteria objects | <pre>map(object({<br/>    # criteria.*.aggregation to be one of [Average Count Minimum Maximum Total]<br/>    aggregation = string<br/>    metric_name = string<br/>    description = string<br/>    # criteria.0.operator to be one of [Equals NotEquals GreaterThan GreaterThanOrEqual LessThan LessThanOrEqual]<br/>    operator  = string<br/>    threshold = number<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M and PT1H<br/>    frequency = string<br/>    # Possible values are PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H and P1D.<br/>    window_size = string<br/><br/>    dimension = list(object(<br/>      {<br/>        name     = string<br/>        operator = string<br/>        values   = list(string)<br/>      }<br/>    ))<br/>  }))</pre> | `{}` | no |
| <a name="input_ehns_sku_name"></a> [ehns\_sku\_name](#input\_ehns\_sku\_name) | Defines which tier to use. | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br/>    idpay = object({<br/>      eventhub_idpay_00 = bool<br/>      eventhub_idpay_01 = bool<br/>      eventhub_rdb      = bool<br/>    })<br/>  })</pre> | <pre>{<br/>  "idpay": {<br/>    "eventhub_idpay_00": false,<br/>    "eventhub_idpay_01": false,<br/>    "eventhub_rdb": false<br/>  }<br/>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_idpay_cdn_storage_account_replication_type"></a> [idpay\_cdn\_storage\_account\_replication\_type](#input\_idpay\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | AKS | `string` | `"~/.kube"` | no |
| <a name="input_law_daily_quota_gb"></a> [law\_daily\_quota\_gb](#input\_law\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. | `number` | `-1` | no |
| <a name="input_law_retention_in_days"></a> [law\_retention\_in\_days](#input\_law\_retention\_in\_days) | The workspace data retention in days | `number` | `30` | no |
| <a name="input_law_sku"></a> [law\_sku](#input\_law\_sku) | Sku of the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_short_weu"></a> [location\_short\_weu](#input\_location\_short\_weu) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_weu"></a> [location\_weu](#input\_location\_weu) | One of westeurope, northeurope | `string` | n/a | yes |
| <a name="input_oneidentity_base_url"></a> [oneidentity\_base\_url](#input\_oneidentity\_base\_url) | OneIdentity base Url | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_redis_idh_resource_tier"></a> [redis\_idh\_resource\_tier](#input\_redis\_idh\_resource\_tier) | The SKU of the Redis Cache to deploy | `string` | n/a | yes |
| <a name="input_robots_indexed_paths"></a> [robots\_indexed\_paths](#input\_robots\_indexed\_paths) | List of cdn paths to allow robots index | `list(string)` | n/a | yes |
| <a name="input_selfcare_welfare_cdn_storage_account_replication_type"></a> [selfcare\_welfare\_cdn\_storage\_account\_replication\_type](#input\_selfcare\_welfare\_cdn\_storage\_account\_replication\_type) | Which replication must use the blob storage under cdn | `string` | n/a | yes |
| <a name="input_service_bus_namespace"></a> [service\_bus\_namespace](#input\_service\_bus\_namespace) | n/a | <pre>object({<br/>    sku                          = string<br/>    capacity                     = optional(number, 0)<br/>    premium_messaging_partitions = optional(number, 0)<br/>  })</pre> | n/a | yes |
| <a name="input_single_page_applications_asset_register_roots_dirs"></a> [single\_page\_applications\_asset\_register\_roots\_dirs](#input\_single\_page\_applications\_asset\_register\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |
| <a name="input_single_page_applications_portal_merchants_operator_roots_dirs"></a> [single\_page\_applications\_portal\_merchants\_operator\_roots\_dirs](#input\_single\_page\_applications\_portal\_merchants\_operator\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |
| <a name="input_single_page_applications_roots_dirs"></a> [single\_page\_applications\_roots\_dirs](#input\_single\_page\_applications\_roots\_dirs) | spa root dirs | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_vmss_idpay_ids"></a> [aks\_vmss\_idpay\_ids](#output\_aks\_vmss\_idpay\_ids) | n/a |
<!-- END_TF_DOCS -->