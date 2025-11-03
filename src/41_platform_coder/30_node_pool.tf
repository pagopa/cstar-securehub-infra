#
# 👤 User node pool
#
module "aks_user_node_pool_keycloak" {
  source = "./.terraform/modules/__v4__/IDH/aks_node_pool"

  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = "Standard_D8ads_v5_active_sdd"

  name           = "usrkeycloak"
  node_count_min = 25
  node_count_max = 25

  node_labels           = { node_name : "usr-keycloak", node_type : "user", domain : "keycloak" }
  node_taints           = []
  node_tags             = {}
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_user_keycloak_snet.id
}
