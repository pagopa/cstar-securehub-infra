locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-d-itn-core"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-d-itn
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-d-itn"

  # AZDO
  azdo_managed_identity_rg_name = "${var.prefix}-${var.env_short}-identity-rg"
  azdo_iac_managed_identities   = toset(["azdo-${var.env}-${var.prefix}-iac-deploy-v2", "azdo-${var.env}-${var.prefix}-iac-plan-v2"])

  prefix_key_vaults = ["core", "cicd"] // e.g. ["core", "cicd"]

  kv_identity_list = flatten([
    for kv in module.key_vault : [
      for identity, id in data.azurerm_user_assigned_identity.iac_federated_azdo : {
        key       = "${identity}@${kv.name}"
        kv_id     = kv.id
        object_id = id.principal_id
        tenant_id = data.azurerm_client_config.current.tenant_id
      }
    ]
  ])

  kv_identity = {
    for i in local.kv_identity_list :
    i.key => {
      kv_id     = i.kv_id
      object_id = i.object_id
      tenant_id = i.tenant_id
    }
  }
}
