module "aks_idpay_node_pool_blue" {
  # source = "./.terraform/modules/__v4__/IDH/storage_account"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/aks_node_pool?ref=PAYMCLOUD-449-idh-node-pool-aks"

  product_name        = var.prefix
  env                 = var.env
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env != "dev" ? "Standard_D8ads_v5" : "Standard_B8ms"

  # Storage Account Settings
  name   = "cs${var.env_short}idpblue"
  node_count_min = var.aks_nodepool_blue.node_count_min
  node_count_max = var.aks_nodepool_blue.node_count_max

  node_labels     = { node_name : "idpay-blue", node_type : "user", domain : var.domain }
  node_taints     = ["${var.domain}Only=true:NoSchedule"]
  node_tags       = { node_tag : "blue" }
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id
}

module "aks_idpay_node_pool_green" {
  # source = "./.terraform/modules/__v4__/IDH/storage_account"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/aks_node_pool?ref=PAYMCLOUD-449-idh-node-pool-aks"

  product_name        = var.prefix
  env                 = var.env
  tags                = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.env != "dev" ? "Standard_D8ads_v5" : "Standard_B8ms"

  # Storage Account Settings
  name   = "cs${var.env_short}idpgreen"

  autoscale_enabled = var.aks_nodepool_green.autoscale_enabled
  node_count_min = var.aks_nodepool_green.node_count_min
  node_count_max = var.aks_nodepool_green.node_count_max
  node_labels     = { node_name : "idpay-green", node_type : "user", domain : var.domain }
  node_taints     = ["${var.domain}Only=true:NoSchedule"]
  node_tags       = { node_tag : "green" }
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id
}
