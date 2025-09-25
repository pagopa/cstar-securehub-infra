module "data_factory" {
  source = "./.terraform/modules/__v4__/data_factory"

  name                = "${local.project}-adf"
  location            = var.location
  resource_group_name = module.default_resource_groups[var.domain].resource_group_names["data"]

  private_endpoint = {
    enabled   = true
    subnet_id = module.adf_snet.id
    private_dns_zone = {
      id   = data.azurerm_private_dns_zone.datafactory.id
      name = data.azurerm_private_dns_zone.datafactory.name
      rg   = data.azurerm_private_dns_zone.datafactory.resource_group_name
    }
  }

  tags = module.tag_config.tags
}
