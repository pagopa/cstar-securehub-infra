moved {
  from = module.aks_srtp_node_pool_blue
  to   = module.aks_srtp_node_pool_blue[0]
}

moved {
  from = module.aks_srtp_node_pool_green
  to   = module.aks_srtp_node_pool_green[0]
}

module "aks_srtp_node_pool_blue" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  count = var.env_short == "u" ? 0 : var.blue_green_node_pool_enabled ? 1 : 0

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
  count = var.blue_green_node_pool_enabled ? 1 : 0

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

module "foo_bar_srtp_node_pool" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  count  = var.aks_foobar_srtp_node_pool_configuration.enabled ? 1 : 0

  product_name      = var.prefix
  env               = var.env
  idh_resource_tier = var.aks_foobar_srtp_node_pool_configuration.tier

  name                  = "srtp"
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_overlay_snet.id

  node_count_min    = var.aks_foobar_srtp_node_pool_configuration.node_count_min
  node_count_max    = var.aks_foobar_srtp_node_pool_configuration.node_count_max
  autoscale_enabled = true

  double_node_pool = {
    enabled = true
    node_pool_foo = {
      active = false
    }
    node_pool_bar = {
      active = true
    }
  }

  node_labels = { node_name : "srtp", node_type : "user", domain : var.domain }
  node_tags   = {}
  node_taints = ["${var.domain}Only=true:NoSchedule"]
  tags        = module.tag_config.tags
}
