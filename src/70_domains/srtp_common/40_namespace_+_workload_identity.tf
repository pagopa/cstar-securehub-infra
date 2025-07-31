resource "kubernetes_namespace" "namespace" {
  count = contains(["d", "u"], var.env_short) ? 1 : 0

  metadata {
    name = var.domain
  }
}

module "workload_identity" {
  count = contains(["d", "u"], var.env_short) ? 1 : 0

  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_init"

  workload_identity_name_prefix         = "${var.domain}-${var.location_short}"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  workload_identity_location            = var.location
}


module "workload_identity_configuration" {
  source = "./.terraform/modules/__v4__/kubernetes_workload_identity_configuration"
  count  = contains(["d", "u"], var.env_short) ? 1 : 0

  workload_identity_name_prefix         = "${var.domain}-${var.location_short}"
  workload_identity_resource_group_name = data.azurerm_kubernetes_cluster.aks.resource_group_name
  aks_name                              = data.azurerm_kubernetes_cluster.aks.name
  aks_resource_group_name               = data.azurerm_kubernetes_cluster.aks.resource_group_name
  namespace                             = var.domain

  key_vault_id                 = data.azurerm_key_vault.domain_kv.id
  key_vault_secret_permissions = ["Get"]

  depends_on = [
    module.workload_identity,
  ]
}
