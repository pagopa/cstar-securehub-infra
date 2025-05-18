#
# General
#
locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}-${var.location_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  tenant_id = data.azurerm_client_config.current.tenant_id

  #
  # 🔐 KV
  #
  rg_name_core_security = "${local.project}-sec-rg"
  core_kv_prefix_names  = ["cicd", "core"]

  #
  # AZDO
  #
  azdo_rg_name = "${local.project}-azdo-rg"
  azdo_iac_managed_identities                 = toset(["azdo-${var.env}-cstar-iac-deploy-v2", "azdo-${var.env}-cstar-iac-plan-v2"])
  legacy_managed_identity_resource_group_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_managed_identity_rg_name               = "${local.project_core}-identity-rg"

}


#
# 🛜 Network
#

locals {
  vnet_hub_name                = "${local.product}-core-hub-vnet"
  vnet_hub_resource_group_name = "${local.product}-core-network-rg"
}
