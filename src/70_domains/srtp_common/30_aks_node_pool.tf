module "aks_user_node_pool" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_user_nodepool.vm_sku_name

  name           = "${var.prefix}${var.env_short}${var.domain}"
  node_count_min = var.aks_user_nodepool.node_count_min
  node_count_max = var.aks_user_nodepool.node_count_max

  node_labels = {
    node_name : "aks-${var.domain}-user",
    node_type : "user",
    domain : var.domain,
  }

  node_taints = [
    "${var.domain}Only=true:NoSchedule"
  ]

  node_tags = {
    node_tag : var.domain,
  }

  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id
}
