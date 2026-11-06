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
      active = var.env_short != "u" ? true : false
    }
    node_pool_bar = {
      active = var.env_short != "u" ? false : true
      #version_override = var.env_short == "p" ? "1.34.3" : null
    }
  }

  node_labels = { node_name : "srtp", node_type : "user", domain : var.domain }
  node_tags   = {}
  node_taints = ["${var.domain}Only=true:NoSchedule"]
  tags        = module.tag_config.tags
}
