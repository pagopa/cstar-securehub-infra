#
# General
#
locals {
  project      = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product      = "${var.prefix}-${var.env_short}"
  project_core = "${var.prefix}-${var.env_short}-${var.location_short}-core"

  tenant_id                     = data.azurerm_client_config.current.tenant_id
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-p4pa-iac-deploy", "azdo-${var.env}-p4pa-iac-plan"])
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
# Api Management
#

locals {

  api_domain        = "api.${var.dns_zone_prefix}.${var.external_domain}"
  api_mtls_domain   = "api-mtls.${var.dns_zone_prefix}.${var.external_domain}"
  portal_domain     = "portal.${var.dns_zone_prefix}.${var.external_domain}"
  management_domain = "management.${var.dns_zone_prefix}.${var.external_domain}"
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

#
# 📜 Cert
#

locals {
  app_gateway_api_certificate_name        = var.env_short == "p" ? "api-p4pa-pagopa-it" : "api-${var.env}-p4pa-pagopa-it"
  app_gateway_api_mtls_certificate_name   = var.env_short == "p" ? "api-mtls-p4pa-pagopa-it" : "api-mtls-${var.env}-p4pa-pagopa-it"
  app_gateway_portal_certificate_name     = var.env_short == "p" ? "portal-p4pa-pagopa-it" : "portal-${var.env}-p4pa-pagopa-it"
  app_gateway_management_certificate_name = var.env_short == "p" ? "management-p4pa-pagopa-it" : "management-${var.env}-p4pa-pagopa-it"
}
