<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.10.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 77d05f98b95c544b4997f02cb94fd53bd4c57eee |
| <a name="module_azdoa_snet"></a> [azdoa\_snet](#module\_azdoa\_snet) | ./.terraform/modules/__v4__/subnet | n/a |
| <a name="module_vnet_core_hub"></a> [vnet\_core\_hub](#module\_vnet\_core\_hub) | ./.terraform/modules/__v4__/virtual_network | n/a |
| <a name="module_vnet_spoke_compute"></a> [vnet\_spoke\_compute](#module\_vnet\_spoke\_compute) | ./.terraform/modules/__v4__/virtual_network | n/a |
| <a name="module_vnet_spoke_data"></a> [vnet\_spoke\_data](#module\_vnet\_spoke\_data) | ./.terraform/modules/__v4__/virtual_network | n/a |
| <a name="module_vnet_spoke_platform_core"></a> [vnet\_spoke\_platform\_core](#module\_vnet\_spoke\_platform\_core) | ./.terraform/modules/__v4__/virtual_network | n/a |
| <a name="module_vnet_spoke_security"></a> [vnet\_spoke\_security](#module\_vnet\_spoke\_security) | ./.terraform/modules/__v4__/virtual_network | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_public_ip.messagi_cortesia_pips](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_core_hub_vnet"></a> [cidr\_core\_hub\_vnet](#input\_cidr\_core\_hub\_vnet) | Address prefixes vnet core | `list(string)` | n/a | yes |
| <a name="input_cidr_spoke_compute_vnet"></a> [cidr\_spoke\_compute\_vnet](#input\_cidr\_spoke\_compute\_vnet) | Address prefixes vnet compute | `list(string)` | n/a | yes |
| <a name="input_cidr_spoke_data_vnet"></a> [cidr\_spoke\_data\_vnet](#input\_cidr\_spoke\_data\_vnet) | Address prefixes vnet data | `list(string)` | n/a | yes |
| <a name="input_cidr_spoke_platform_core_vnet"></a> [cidr\_spoke\_platform\_core\_vnet](#input\_cidr\_spoke\_platform\_core\_vnet) | Address prefixes vnet platform core | `list(string)` | n/a | yes |
| <a name="input_cidr_spoke_security_vnet"></a> [cidr\_spoke\_security\_vnet](#input\_cidr\_spoke\_security\_vnet) | Address prefixes vnet security | `list(string)` | n/a | yes |
| <a name="input_cidr_subnet_azdoa"></a> [cidr\_subnet\_azdoa](#input\_cidr\_subnet\_azdoa) | Azure DevOps agent network address space. | `list(string)` | n/a | yes |
| <a name="input_default_zones"></a> [default\_zones](#input\_default\_zones) | (Optional) List of availability zones | `list(number)` | `[]` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_nat_idle_timeout_in_minutes"></a> [nat\_idle\_timeout\_in\_minutes](#input\_nat\_idle\_timeout\_in\_minutes) | The idle timeout which should be used in minutes. | `number` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(any)` | <pre>{<br/>  "CreatedBy": "Terraform"<br/>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
