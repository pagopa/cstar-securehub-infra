module "aks_srtp_node_pool_blue" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_nodepool_blue.vm_sku_name

  name           = "cs${var.env_short}bluesrtp"
  node_count_min = var.aks_nodepool_blue.node_count_min
  node_count_max = var.aks_nodepool_blue.node_count_max

  node_labels = {
    node_name : "srtp-blue",
    node_type : "user",
    domain : var.domain,
    phase : "blue",
  }

  node_taints = [
    "${var.domain}Only=true:NoSchedule"
  ]

  node_tags = {
    node_tag : "blue",
    phase : "blue",
  }

  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id
}

module "aks_srtp_node_pool_green" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//IDH/aks_node_pool?ref=PAYMCLOUD-449-idh-node-pool-aks"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_nodepool_green.vm_sku_name

  name = "cs${var.env_short}grensrtp"

  autoscale_enabled     = var.aks_nodepool_green.autoscale_enabled
  node_count_min        = var.aks_nodepool_green.node_count_min
  node_count_max        = var.aks_nodepool_green.node_count_max
  node_labels           = { node_name : "srtp-green", node_type : "user", domain : var.domain, phase : "green" }
  node_taints           = ["${var.domain}Only=true:NoSchedule"]
  node_tags             = { node_tag : "green", phase : "green" }
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id
}
