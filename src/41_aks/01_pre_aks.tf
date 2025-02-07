resource "azurerm_resource_group" "aks_rg" {
  name     = local.aks_resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_public_ip" "aks_outbound" {
  count = var.aks_num_outbound_ips

  name                = "${local.project}-aks-outbound-pip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
  zones               = var.aks_ip_availability_zones

  tags = var.tags
}
