# Kubernetes Cluster

## How to install the first time

### Disable components

99_main.tf:

* disable helm and k8s providers, because the aks is undercostruction

04_ingress.tf
04_keda.tf
04_rbac.tf

Comment this files because a cluster is mandatory to work

### Cluster Creation

Launch the cluster creation

### Re-enable resources

Re-enable all the resource, commented before to complete the procedure

<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.38.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 72032dcc751b7f82af6948dfc3f4fafb4abfcaf1 |
| <a name="module_argocd_entra"></a> [argocd\_entra](#module\_argocd\_entra) | ./.terraform/modules/__v4__/kubernetes_argocd_entra | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_group.argocd_groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.graph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_users.argocd_application_owners](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/users) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.kv_core_ita](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argocd_entra_groups_allowed"></a> [argocd\_entra\_groups\_allowed](#input\_argocd\_entra\_groups\_allowed) | Definizione della variabile per i nomi dei gruppi Entra ID | `list(string)` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: weu, weu.. | `string` | n/a | yes |
| <a name="input_location_westeurope"></a> [location\_westeurope](#input\_location\_westeurope) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"cstar"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
