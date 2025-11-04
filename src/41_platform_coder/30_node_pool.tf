#
# 👤 User node pool
#
module "aks_user_node_pool_keycloak" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_user_node_pool_keycloak.idh_resource_tier
  os_disk_size_gb   = var.aks_user_node_pool_keycloak.os_disk_size_gb
  os_disk_type      = var.aks_user_node_pool_keycloak.os_disk_type

  name           = "usrkeycloak"
  node_count_min = var.aks_user_node_pool_keycloak.node_count_min
  node_count_max = var.aks_user_node_pool_keycloak.node_count_max

  node_labels = {
    node_name : "usr-keycloak",
    node_type : "user",
    domain : "keycloak"
  }
  node_taints           = []
  node_tags             = {}
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_user_keycloak_snet.id
}
