# This file contains the resources that were used for testing in the DEV and UAT environments
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

#----------------------------------------------------------------
# 🔎 DNS
#----------------------------------------------------------------
resource "azurerm_private_dns_a_record" "ingress_qa" {
  count = contains(["d", "u"], var.env_short) ? 1 : 0

  name                = "qa"
  zone_name           = local.dns_zone_internal
  resource_group_name = local.vnet_legacy_core_rg
  ttl                 = 3600
  records             = [local.ingress_private_load_balancer_ip]
}
