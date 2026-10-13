moved {
  from = module.aks_node_pool
  to   = module.aks_node_pool[0]
}

module "aks_node_pool" {
  source       = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  count        = var.aks_nodepool.enabled ? 1 : 0
  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_nodepool.vm_sku_name

  name           = "${var.prefix}${var.env_short}${var.domain}"
  node_count_min = var.aks_nodepool.node_count_min
  node_count_max = var.aks_nodepool.node_count_max

  node_labels           = { node_name : var.prefix, node_type : "user", domain : var.domain }
  node_tags             = {}
  node_taints           = ["${var.domain}Only=true:NoSchedule"]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id

  resource_group_nsg_name = local.network_rg
  embedded_subnet = {
    enabled      = true
    subnet_name  = local.project
    vnet_rg_name = local.vnet_network_rg
    vnet_name    = local.vnet_spoke_compute_name
    natgw_id     = data.azurerm_nat_gateway.compute_nat_gateway.id
  }
}


module "aks_foobar_node_pool" {
  source       = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  count        = var.aks_foobar_nodepool.enabled ? 1 : 0
  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_foobar_nodepool.vm_sku_name

  name           = var.domain
  node_count_min = var.aks_foobar_nodepool.node_count_min
  node_count_max = var.aks_foobar_nodepool.node_count_max

  node_labels           = { node_name : var.prefix, node_type : "user", domain : var.domain }
  node_tags             = {}
  node_taints           = ["${var.domain}Only=true:NoSchedule"]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id

  double_node_pool = {
    enabled = true
    node_pool_foo = {
      active = true
    }
    node_pool_bar = {
      active = false
    }
  }

  resource_group_nsg_name = local.network_rg
  embedded_subnet = {
    enabled      = true
    subnet_name  = "${local.project}-foobar"
    vnet_rg_name = local.vnet_network_rg
    vnet_name    = local.vnet_spoke_compute_name
    natgw_id     = data.azurerm_nat_gateway.compute_nat_gateway.id
  }
}
