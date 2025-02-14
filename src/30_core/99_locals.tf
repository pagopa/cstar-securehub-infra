#
# General
#
locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  tenant_id                     = data.azurerm_client_config.current.tenant_id
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-cstar-iac-deploy", "azdo-${var.env}-cstar-iac-plan"])
  azdo_managed_identity_rg_name = "${local.project_core}-identity-rg"
  azdo_managed_identity_name    = upper("${var.env}-${var.prefix}-AZURE")
}

#
# Network
#

locals {
  vnet_name                = "${local.product}-${var.location_short}-core-vnet"
  vnet_resource_group_name = "${local.product}-${var.location_short}-core-vnet-rg"
}

#
# 🔐 KV
#

locals {
  kv_id_core                  = data.azurerm_key_vault.key_vault.id
  rg_name_core_security       = "${local.project}-sec-rg"
  kv_name_domain              = "${local.product}-${var.domain}-kv"
  kv_ingress_certificate_name = "hub.internal.${var.env}.${var.prefix}.${var.external_domain}"
}
