locals {
  project           = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_no_domain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product           = "${var.prefix}-${var.env_short}"

  #
  # 🌐 Network
  #
  vnet_core_rg_name       = "${local.product}-vnet-rg"
  vnet_spoke_data_name    = "${local.project_no_domain}-core-spoke-data-vnet"
  vnet_spoke_data_rg_name = "${local.project_no_domain}-core-network-rg"

  #
  # 🔑 KeyVault
  #
  idpay_kv_name    = "${local.project}-kv"
  idpay_kv_rg_name = "${local.project}-security-rg"

  #
  # AKS
  #
  aks_name                = "${local.project_no_domain}-${var.env}-aks"
  aks_resource_group_name = "${local.project_no_domain}-core-aks-rg"

  # monitor_action_group_slack_name = "SlackPagoPA"
  # monitor_action_group_email_name = "PagoPA"
  #
  # vnet_core_name                = "${local.product}-vnet"
  # vnet_core_resource_group_name = "${local.product}-vnet-rg"
  #
  # container_registry_common_name    = "${local.project}-common-acr"
  # rg_container_registry_common_name = "${local.project}-container-registry-rg"
  #
  # core = {
  #   event_hub = {
  #     namespace_name      = "cstar-${var.env_short}-evh-ns"
  #     resource_group_name = "cstar-${var.env_short}-msg-rg"
  #   }
  # }
  #
  # azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  # azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

}
