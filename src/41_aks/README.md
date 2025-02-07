<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.114 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.27 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.15.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.30.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v3__"></a> [\_\_v3\_\_](#module\_\_\_v3\_\_) | git::https://github.com/pagopa/terraform-azurerm-v3.git | 2322581d8c88868e17eef5a1c780a1e9ec9bcafc |
| <a name="module_aks"></a> [aks](#module\_aks) | ./.terraform/modules/__v3__/kubernetes_cluster | n/a |
| <a name="module_aks_prometheus_install"></a> [aks\_prometheus\_install](#module\_aks\_prometheus\_install) | ./.terraform/modules/__v3__/kubernetes_prometheus_install | n/a |
| <a name="module_aks_snet_system"></a> [aks\_snet\_system](#module\_aks\_snet\_system) | ./.terraform/modules/__v3__/subnet | n/a |
| <a name="module_aks_snet_user"></a> [aks\_snet\_user](#module\_aks\_snet\_user) | ./.terraform/modules/__v3__/subnet | n/a |
| <a name="module_aks_storage_class"></a> [aks\_storage\_class](#module\_aks\_storage\_class) | ./.terraform/modules/__v3__/kubernetes_storage_class | n/a |
| <a name="module_argocd_workload_identity_configuration"></a> [argocd\_workload\_identity\_configuration](#module\_argocd\_workload\_identity\_configuration) | ./.terraform/modules/__v3__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_argocd_workload_identity_init"></a> [argocd\_workload\_identity\_init](#module\_argocd\_workload\_identity\_init) | ./.terraform/modules/__v3__/kubernetes_workload_identity_init | n/a |
| <a name="module_cert_mounter_argocd_internal"></a> [cert\_mounter\_argocd\_internal](#module\_cert\_mounter\_argocd\_internal) | ./.terraform/modules/__v3__/cert_mounter | n/a |
| <a name="module_keda_workload_identity_configuration"></a> [keda\_workload\_identity\_configuration](#module\_keda\_workload\_identity\_configuration) | ./.terraform/modules/__v3__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_keda_workload_identity_init"></a> [keda\_workload\_identity\_init](#module\_keda\_workload\_identity\_init) | ./.terraform/modules/__v3__/kubernetes_workload_identity_init | n/a |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | terraform-module/release/helm | 2.8.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster_node_pool.user_nodepool_default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_private_dns_a_record.argocd](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.ingress](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_public_ip.aks_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.aks_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.adgroup_eng_spa_externals_rbac_writer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.adgroup_eng_spa_externals_reader_aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.aks_to_acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.keda_monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.managed_identity_operator_vs_aks_managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader_argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.kube_system_reader](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.system_cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.view_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.edit_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.keda](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.namespace_argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.prometheus](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [null_resource.argocd_change_admin_password](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_eng_spa_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_operations](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_technical_project_managers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_container_registry.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) | data source |
| [azurerm_key_vault.key_vault_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.argocd_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.argocd_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_alerts_enabled"></a> [aks\_alerts\_enabled](#input\_aks\_alerts\_enabled) | AKS alerts enabled? | `bool` | `false` | no |
| <a name="input_aks_cidr_system_subnet"></a> [aks\_cidr\_system\_subnet](#input\_aks\_cidr\_system\_subnet) | Aks system network address space. | `list(string)` | n/a | yes |
| <a name="input_aks_cidr_user_subnet"></a> [aks\_cidr\_user\_subnet](#input\_aks\_cidr\_user\_subnet) | Aks user network address space. | `list(string)` | n/a | yes |
| <a name="input_aks_ip_availability_zones"></a> [aks\_ip\_availability\_zones](#input\_aks\_ip\_availability\_zones) | List of zones | `list(string)` | <pre>[<br/>  "1",<br/>  "2",<br/>  "3"<br/>]</pre> | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Kubernetes version specified when creating the AKS managed cluster. | `string` | n/a | yes |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_private_cluster_is_enabled"></a> [aks\_private\_cluster\_is\_enabled](#input\_aks\_private\_cluster\_is\_enabled) | Allow to configure the AKS, to be setup as a private cluster. To reach it, you need to use an internal VM or VPN | `bool` | `true` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). | `string` | n/a | yes |
| <a name="input_aks_system_node_pool"></a> [aks\_system\_node\_pool](#input\_aks\_system\_node\_pool) | AKS node pool system configuration | <pre>object({<br/>    name                         = string<br/>    vm_size                      = string<br/>    os_disk_type                 = string<br/>    os_disk_size_gb              = string<br/>    node_count_min               = number<br/>    node_count_max               = number<br/>    only_critical_addons_enabled = bool<br/>    node_labels                  = map(any)<br/>    node_tags                    = map(any)<br/>  })</pre> | n/a | yes |
| <a name="input_aks_user_node_pool_standalone"></a> [aks\_user\_node\_pool\_standalone](#input\_aks\_user\_node\_pool\_standalone) | AKS node pool user configuration | <pre>object({<br/>    enabled                    = optional(bool, true),<br/>    name                       = string,<br/>    vm_size                    = string,<br/>    os_disk_type               = string,<br/>    os_disk_size_gb            = string,<br/>    node_count_min             = number,<br/>    node_count_max             = number,<br/>    node_labels                = map(any),<br/>    node_taints                = list(string),<br/>    node_tags                  = map(any),<br/>    ultra_ssd_enabled          = optional(bool, false),<br/>    enable_host_encryption     = optional(bool, true),<br/>    max_pods                   = optional(number, 250),<br/>    upgrade_settings_max_surge = optional(string, "30%"),<br/>    zones                      = optional(list(any), [1, 2, 3]),<br/>  })</pre> | n/a | yes |
| <a name="input_argocd_helm_release_version"></a> [argocd\_helm\_release\_version](#input\_argocd\_helm\_release\_version) | ArgoCD helm chart release version | `string` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_keda_helm_chart_version"></a> [keda\_helm\_chart\_version](#input\_keda\_helm\_chart\_version) | keda helm chart version | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_nginx_ingress_helm_version"></a> [nginx\_ingress\_helm\_version](#input\_nginx\_ingress\_helm\_version) | Nginx ingress helm version https://github.com/kubernetes/ingress-nginx | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
