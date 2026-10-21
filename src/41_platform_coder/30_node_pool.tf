#
# 👤 User node pool
#
moved {
  from = module.aks_user_node_pool_keycloak
  to   = module.aks_user_node_pool_keycloak[0]
}


module "aks_user_node_pool_keycloak" {
  source       = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  count        = var.aks_user_node_pool_keycloak.enabled ? 1 : 0
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
  node_taints = [
    "keycloakOnly=true:NoSchedule"
  ]

  node_tags             = {}
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_user_keycloak_snet.id
}


module "aks_user_foobar_node_pool_keycloak" {
  source       = "./.terraform/modules/__v4__/IDH/aks_node_pool"
  count        = var.aks_user_foobar_node_pool_keycloak.enabled ? 1 : 0
  product_name = var.prefix
  env          = var.env
  tags         = module.tag_config.tags

  # IDH Resources
  idh_resource_tier = var.aks_user_foobar_node_pool_keycloak.idh_resource_tier
  os_disk_size_gb   = var.aks_user_foobar_node_pool_keycloak.os_disk_size_gb
  os_disk_type      = var.aks_user_foobar_node_pool_keycloak.os_disk_type

  name           = "keyclk"
  node_count_min = var.aks_user_foobar_node_pool_keycloak.node_count_min
  node_count_max = var.aks_user_foobar_node_pool_keycloak.node_count_max

  double_node_pool = {
    enabled = true
    node_pool_foo = {
      active = var.env_short == "d" ? true : false
    }
    node_pool_bar = {
      active           = var.env_short == "d" ? false : true
      version_override = var.env_short == "d" ? null : "1.35.8"
    }
  }

  node_labels = {
    node_name : "usr-keycloak",
    node_type : "user",
    domain : "keycloak"
  }
  node_taints = [
    "keycloakOnly=true:NoSchedule"
  ]

  node_tags             = {}
  kubernetes_cluster_id = data.azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = module.aks_user_keycloak_snet.id
}
