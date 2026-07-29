locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  # AZDO
  azdo_managed_identity_rg_name = "${local.product}-identity-rg"

  azdo_iac_managed_identities_read = toset([
    "azdo-${var.env}-${var.prefix}-iac-plan-v2",
    "azdo-${var.env}-${var.prefix}-app-plan-v2",
  ])

  azdo_iac_managed_identities_write = toset([
    "azdo-${var.env}-${var.prefix}-iac-deploy-v2",
    "azdo-${var.env}-${var.prefix}-app-deploy-v2"
  ])

  input_file = "./secrets/${var.domain}/${var.location_short}-${var.env}"

  domains = toset(["idpay"])

  ad_group_definitions = flatten([
    for i in local.domains : [
      {
        type      = "admin"
        domain    = i
        rbac_role = "Key Vault Secrets Officer"
      }
    ]
  ])
  ad_groups = {
    for item in local.ad_group_definitions :
    "${item.domain}-${item.type}" => {
      display_name = "${var.prefix}-${var.env_short}-${item.domain}-adgroup-${item.type}"
      type         = item.type
      rbac_role    = item.rbac_role
    }
  }

}
