<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_argocd"></a> [argocd](#requirement\_argocd) | ~> 7.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 1.11.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | <= 4.25 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.17.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.36.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_terracurl"></a> [terracurl](#requirement\_terracurl) | 1.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_argocd"></a> [argocd](#provider\_argocd) | 7.8.2 |
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.11.0 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 8265f125b07251a5efe7b9ff57707109de8b46ba |
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | ./.terraform/modules/__v4__/cert_mounter | n/a |

## Resources

| Name | Type |
|------|------|
| [argocd_application.domain_argocd_applications](https://registry.terraform.io/providers/argoproj-labs/argocd/latest/docs/resources/application) | resource |
| [azapi_resource.idpay_workbook](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_eventhub_namespace_authorization_rule.evh_namespace_access_key_00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_key_vault_secret.event_hub_root_key_idpay_00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.appinsights-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-common](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-00](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-01](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-02](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.idpay-eventhub-rdb](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.notification-email](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rest-client](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.rtd-eventhub](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [null_resource.transaction_in_progress_connector](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_eventhub_namespace.eventhub_00](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/eventhub_namespace) | data source |
| [azurerm_key_vault.key_vault_domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argocd_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.workload_identity_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.workload_identity_service_account_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_cluster_domain_name"></a> [aks\_cluster\_domain\_name](#input\_aks\_cluster\_domain\_name) | Name of the aks cluster domain. eg: dev01 | `string` | n/a | yes |
| <a name="input_aks_name"></a> [aks\_name](#input\_aks\_name) | AKS cluster name | `string` | n/a | yes |
| <a name="input_aks_resource_group_name"></a> [aks\_resource\_group\_name](#input\_aks\_resource\_group\_name) | AKS cluster resource name | `string` | n/a | yes |
| <a name="input_aks_vmss_name"></a> [aks\_vmss\_name](#input\_aks\_vmss\_name) | AKS nodepool scale set name | `string` | n/a | yes |
| <a name="input_checkiban_base_url"></a> [checkiban\_base\_url](#input\_checkiban\_base\_url) | Check IBAN uri. | `string` | `"127.0.0.1"` | no |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Feature flags | <pre>object({<br/>    mock_io_api = bool<br/>  })</pre> | <pre>{<br/>  "mock_io_api": false<br/>}</pre> | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_event_hub_port"></a> [event\_hub\_port](#input\_event\_hub\_port) | n/a | `number` | `9093` | no |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_idpay_alert_enabled"></a> [idpay\_alert\_enabled](#input\_idpay\_alert\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_idpay_mocked_acquirer_apim_user_id"></a> [idpay\_mocked\_acquirer\_apim\_user\_id](#input\_idpay\_mocked\_acquirer\_apim\_user\_id) | APIm user id of mocked acquirer | `string` | `null` | no |
| <a name="input_idpay_mocked_merchant_enable"></a> [idpay\_mocked\_merchant\_enable](#input\_idpay\_mocked\_merchant\_enable) | Enable mocked merchant APIs | `bool` | `false` | no |
| <a name="input_ingress_domain_hostname"></a> [ingress\_domain\_hostname](#input\_ingress\_domain\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_instance"></a> [instance](#input\_instance) | One of beta, prod01, prod02 | `string` | n/a | yes |
| <a name="input_io_manage_backend_base_url"></a> [io\_manage\_backend\_base\_url](#input\_io\_manage\_backend\_base\_url) | BE IO manage backend url | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_location"></a> [location](#input\_location) | One of italynorth, northeurope | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | One of wue, neu | `string` | n/a | yes |
| <a name="input_location_string"></a> [location\_string](#input\_location\_string) | One of Italy North, North Europe | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Specifies the name of the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_resource_group_name"></a> [log\_analytics\_workspace\_resource\_group\_name](#input\_log\_analytics\_workspace\_resource\_group\_name) | The name of the resource group in which the Log Analytics workspace is located in. | `string` | n/a | yes |
| <a name="input_mail_server_host"></a> [mail\_server\_host](#input\_mail\_server\_host) | SMTP server hostname | `string` | n/a | yes |
| <a name="input_mail_server_port"></a> [mail\_server\_port](#input\_mail\_server\_port) | SMTP server port | `string` | `"587"` | no |
| <a name="input_mail_server_protocol"></a> [mail\_server\_protocol](#input\_mail\_server\_protocol) | mail protocol | `string` | `"smtp"` | no |
| <a name="input_mil_issuer_url"></a> [mil\_issuer\_url](#input\_mil\_issuer\_url) | MIL issuer url | `string` | n/a | yes |
| <a name="input_mil_openid_url"></a> [mil\_openid\_url](#input\_mil\_openid\_url) | OpenId MIL url | `string` | n/a | yes |
| <a name="input_monitor_resource_group_name"></a> [monitor\_resource\_group\_name](#input\_monitor\_resource\_group\_name) | Monitor resource group name | `string` | n/a | yes |
| <a name="input_one_trust_privacynotice_base_url"></a> [one\_trust\_privacynotice\_base\_url](#input\_one\_trust\_privacynotice\_base\_url) | OneTrust PrivacyNotice Base Url | `string` | n/a | yes |
| <a name="input_openid_config_url_mil"></a> [openid\_config\_url\_mil](#input\_openid\_config\_url\_mil) | Token MIL, OIDC URL | `string` | n/a | yes |
| <a name="input_pdv_retry_count"></a> [pdv\_retry\_count](#input\_pdv\_retry\_count) | PDV max retry number | `number` | `3` | no |
| <a name="input_pdv_retry_delta"></a> [pdv\_retry\_delta](#input\_pdv\_retry\_delta) | PDV delta | `number` | `1` | no |
| <a name="input_pdv_retry_interval"></a> [pdv\_retry\_interval](#input\_pdv\_retry\_interval) | PDV interval between each retry | `number` | `5` | no |
| <a name="input_pdv_retry_max_interval"></a> [pdv\_retry\_max\_interval](#input\_pdv\_retry\_max\_interval) | PDV max interval between each retry | `number` | `15` | no |
| <a name="input_pdv_timeout_sec"></a> [pdv\_timeout\_sec](#input\_pdv\_timeout\_sec) | PDV timeout (sec) | `number` | `15` | no |
| <a name="input_pdv_tokenizer_url"></a> [pdv\_tokenizer\_url](#input\_pdv\_tokenizer\_url) | PDV uri. Endpoint for encryption of pii information. | `string` | `"127.0.0.1"` | no |
| <a name="input_pm_backend_url"></a> [pm\_backend\_url](#input\_pm\_backend\_url) | Payment manager backend url (enrollment) | `string` | n/a | yes |
| <a name="input_pm_service_base_url"></a> [pm\_service\_base\_url](#input\_pm\_service\_base\_url) | PM Service uri. Endpoint to retrieve Payment Instruments information. | `string` | `"127.0.0.1"` | no |
| <a name="input_pm_timeout_sec"></a> [pm\_timeout\_sec](#input\_pm\_timeout\_sec) | Payment manager timeout (sec) | `number` | `5` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_rate_limit_assistance_product"></a> [rate\_limit\_assistance\_product](#input\_rate\_limit\_assistance\_product) | Rate limit for Assistance product | `number` | `1000` | no |
| <a name="input_rate_limit_io_product"></a> [rate\_limit\_io\_product](#input\_rate\_limit\_io\_product) | Rate limit for IO product | `number` | `2500` | no |
| <a name="input_rate_limit_issuer_product"></a> [rate\_limit\_issuer\_product](#input\_rate\_limit\_issuer\_product) | Rate limit for Issuer product | `number` | `2000` | no |
| <a name="input_rate_limit_merchants_portal_product"></a> [rate\_limit\_merchants\_portal\_product](#input\_rate\_limit\_merchants\_portal\_product) | Rate limit for merchants portal product | `number` | `2500` | no |
| <a name="input_rate_limit_mil_citizen_product"></a> [rate\_limit\_mil\_citizen\_product](#input\_rate\_limit\_mil\_citizen\_product) | Rate limit for MIL citizen product | `number` | `2000` | no |
| <a name="input_rate_limit_mil_merchant_product"></a> [rate\_limit\_mil\_merchant\_product](#input\_rate\_limit\_mil\_merchant\_product) | Rate limit for MIL merchant product | `number` | `2000` | no |
| <a name="input_rate_limit_minint_product"></a> [rate\_limit\_minint\_product](#input\_rate\_limit\_minint\_product) | Rate limit for MIN INT product | `number` | `1000` | no |
| <a name="input_rate_limit_portal_product"></a> [rate\_limit\_portal\_product](#input\_rate\_limit\_portal\_product) | Rate limit for institutions portal product | `number` | `2500` | no |
| <a name="input_reverse_proxy_be_io"></a> [reverse\_proxy\_be\_io](#input\_reverse\_proxy\_be\_io) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_reverse_proxy_rtd"></a> [reverse\_proxy\_rtd](#input\_reverse\_proxy\_rtd) | AKS external ip. Also the ingress-nginx-controller external ip. Value known after installing the ingress controller. | `string` | `"127.0.0.1"` | no |
| <a name="input_selc_base_url"></a> [selc\_base\_url](#input\_selc\_base\_url) | SelfCare api backend url | `string` | n/a | yes |
| <a name="input_selc_timeout_sec"></a> [selc\_timeout\_sec](#input\_selc\_timeout\_sec) | SelfCare api timeout (sec) | `number` | `5` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. Changing this forces a new resource to be created when types LRS, GRS and RAGRS are changed to ZRS, GZRS or RAGZRS and vice versa | `string` | `"LRS"` | no |
| <a name="input_storage_advanced_threat_protection"></a> [storage\_advanced\_threat\_protection](#input\_storage\_advanced\_threat\_protection) | Enable threat advanced protection | `bool` | `false` | no |
| <a name="input_storage_delete_retention_days"></a> [storage\_delete\_retention\_days](#input\_storage\_delete\_retention\_days) | Number of days to retain deleted files | `number` | `5` | no |
| <a name="input_storage_enable_versioning"></a> [storage\_enable\_versioning](#input\_storage\_enable\_versioning) | Enable versioning | `bool` | `false` | no |
| <a name="input_storage_public_network_access_enabled"></a> [storage\_public\_network\_access\_enabled](#input\_storage\_public\_network\_access\_enabled) | Enable public network access | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_webViewUrl"></a> [webViewUrl](#input\_webViewUrl) | WebView Url | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
