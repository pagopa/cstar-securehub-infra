module "aks_node_pool" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = "Standard_B4ms_active" #var.aks_nodepool_blue.idh_resource_tier

  name           = "${var.prefix}${var.env_short}${var.domain}"
  node_count_min = 1 #var.aks_nodepool_blue.node_count_min
  node_count_max = 1 #var.aks_nodepool_blue.node_count_max

  node_labels           = { node_name : var.prefix, node_type : "user", domain : var.domain }
  node_tags             = {}
  node_taints           = ["${var.domain}Only=true:NoSchedule"]
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  embedded_subnet = {
    enabled      = true
    subnet_name  = local.project
    vnet_rg_name = local.vnet_network_rg
    vnet_name    = local.vnet_spoke_compute_name
    natgw_id     = data.azurerm_nat_gateway.compute_nat_gateway.id
  }
}
