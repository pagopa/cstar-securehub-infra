## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 2.53 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | = 2.17.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | = 2.36.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.26.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 05a78d5bf1f5cd1d82626f82c6f3e8dd653833f7 |
| <a name="module_aks"></a> [aks](#module\_aks) | ./.terraform/modules/__v4__/kubernetes_cluster | n/a |
| <a name="module_aks_snet"></a> [aks\_snet](#module\_aks\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_aks_user_snet"></a> [aks\_user\_snet](#module\_aks\_user\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_keda_pod_identity"></a> [keda\_pod\_identity](#module\_keda\_pod\_identity) | ./.terraform/modules/__v4__/kubernetes_pod_identity | n/a |
| <a name="module_nginx_ingress"></a> [nginx\_ingress](#module\_nginx\_ingress) | terraform-module/release/helm | 2.8.0 |
| <a name="module_prometheus_managed_addon"></a> [prometheus\_managed\_addon](#module\_prometheus\_managed\_addon) | ./.terraform/modules/__v4__/kubernetes_prometheus_managed | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.aks_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.keda_monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [helm_release.keda](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [helm_release.monitoring_reloader](https://registry.terraform.io/providers/hashicorp/helm/2.17.0/docs/resources/release) | resource |
| [kubernetes_cluster_role.cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.edit_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.kube_system_reader](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.system_cluster_deployer](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role.view_extra](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.edit_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.edit_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.view_extra_binding](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.keda](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/namespace) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/2.36.0/docs/resources/namespace) | resource |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_log_analytics_workspace.log_analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_monitor_action_group.email](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.opsgenie](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_action_group.slack](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_action_group) | data source |
| [azurerm_monitor_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_workspace) | data source |
| [azurerm_nat_gateway.compute_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/nat_gateway) | data source |
| [azurerm_public_ip.compute_nat_gateway_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/public_ip) | data source |
| [azurerm_resource_group.monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.vnet_compute_spoke_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.vnet_compute_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_alerts_enabled"></a> [aks\_alerts\_enabled](#input\_aks\_alerts\_enabled) | AKS alerts enabled? | `bool` | `false` | no |
| <a name="input_aks_cidr_subnet"></a> [aks\_cidr\_subnet](#input\_aks\_cidr\_subnet) | Aks network address space. | `list(string)` | n/a | yes |
| <a name="input_aks_cidr_subnet_user"></a> [aks\_cidr\_subnet\_user](#input\_aks\_cidr\_subnet\_user) | Aks network address space for user pool. | `list(string)` | n/a | yes |
| <a name="input_aks_enable_workload_identity"></a> [aks\_enable\_workload\_identity](#input\_aks\_enable\_workload\_identity) | n/a | `bool` | `false` | no |
| <a name="input_aks_kubernetes_version"></a> [aks\_kubernetes\_version](#input\_aks\_kubernetes\_version) | Kubernetes version specified when creating the AKS managed cluster. | `string` | `"1.22.6"` | no |
| <a name="input_aks_num_outbound_ips"></a> [aks\_num\_outbound\_ips](#input\_aks\_num\_outbound\_ips) | How many outbound ips allocate for AKS cluster | `number` | `1` | no |
| <a name="input_aks_private_cluster_is_enabled"></a> [aks\_private\_cluster\_is\_enabled](#input\_aks\_private\_cluster\_is\_enabled) | Allow to configure the AKS, to be setup as a private cluster. To reach it, you need to use an internal VM or VPN | `bool` | `true` | no |
| <a name="input_aks_sku_tier"></a> [aks\_sku\_tier](#input\_aks\_sku\_tier) | The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). | `string` | n/a | yes |
| <a name="input_aks_system_node_pool"></a> [aks\_system\_node\_pool](#input\_aks\_system\_node\_pool) | AKS node pool system configuration | <pre>object({<br/>    name                         = string,<br/>    vm_size                      = string,<br/>    os_disk_type                 = string,<br/>    os_disk_size_gb              = string,<br/>    node_count_min               = number,<br/>    node_count_max               = number,<br/>    only_critical_addons_enabled = bool,<br/>    node_labels                  = map(any),<br/>    node_tags                    = map(any)<br/>  })</pre> | n/a | yes |
| <a name="input_aks_user_node_pool"></a> [aks\_user\_node\_pool](#input\_aks\_user\_node\_pool) | AKS node pool user configuration | <pre>object({<br/>    enabled         = bool,<br/>    name            = string,<br/>    vm_size         = string,<br/>    os_disk_type    = string,<br/>    os_disk_size_gb = string,<br/>    node_count_min  = number,<br/>    node_count_max  = number,<br/>    node_labels     = map(any),<br/>    node_taints     = list(string),<br/>    node_tags       = map(any)<br/>  })</pre> | n/a | yes |
| <a name="input_default_zones"></a> [default\_zones](#input\_default\_zones) | List of zones in which the scale set will be deployed | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_ingress_load_balancer_ip"></a> [ingress\_load\_balancer\_ip](#input\_ingress\_load\_balancer\_ip) | n/a | `string` | n/a | yes |
| <a name="input_ingress_max_replica_count"></a> [ingress\_max\_replica\_count](#input\_ingress\_max\_replica\_count) | n/a | `string` | n/a | yes |
| <a name="input_ingress_min_replica_count"></a> [ingress\_min\_replica\_count](#input\_ingress\_min\_replica\_count) | n/a | `string` | n/a | yes |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | n/a | `string` | `"~/.kube"` | no |
| <a name="input_keda_helm"></a> [keda\_helm](#input\_keda\_helm) | keda helm chart configuration | <pre>object({<br/>    chart_version = string,<br/>    keda = object({<br/>      image_name = string,<br/>      image_tag  = string,<br/>    }),<br/>    metrics_api_server = object({<br/>      image_name = string,<br/>      image_tag  = string,<br/>    }),<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_nginx_helm"></a> [nginx\_helm](#input\_nginx\_helm) | nginx ingress helm chart configuration | <pre>object({<br/>    version = string,<br/>    controller = object({<br/>      image = object({<br/>        registry     = string,<br/>        image        = string,<br/>        tag          = string,<br/>        digest       = string,<br/>        digestchroot = string,<br/>      }),<br/>      resources = object({<br/>        requests = object({<br/>          memory : string<br/>        })<br/>      }),<br/>      config = object({<br/>        proxy-body-size : string<br/>      })<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | # General | `string` | n/a | yes |
| <a name="input_reloader_helm"></a> [reloader\_helm](#input\_reloader\_helm) | reloader helm chart configuration | <pre>object({<br/>    chart_version = string,<br/>    image_name    = string,<br/>    image_tag     = string<br/>  })</pre> | n/a | yes |
| <a name="input_skip_metric_validation"></a> [skip\_metric\_validation](#input\_skip\_metric\_validation) | (Optional) Skip the metric validation to allow creating an alert rule on a custom metric that isn't yet emitted? Defaults to false. | `bool` | `false` | no |
| <a name="input_subnet_private_endpoint_network_policies_enabled"></a> [subnet\_private\_endpoint\_network\_policies\_enabled](#input\_subnet\_private\_endpoint\_network\_policies\_enabled) | (Optional) Enable or Disable network policies for the private endpoint on the subnet. Possible values are Disabled, Enabled, NetworkSecurityGroupEnabled and RouteTableEnabled. Defaults to Disabled. | `string` | `"Disabled"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
