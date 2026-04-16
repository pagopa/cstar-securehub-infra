locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-d-itn-core"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-d-itn
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-d-itn"

  prefix_key_vaults = ["core", "cicd"] // e.g. ["core", "cicd"]


  domain_ad_group_rbac = flatten([
    var.env_short != "p" ? [
      {
        object_id    = data.azuread_group.idpay_adgroup_domain_admin.object_id
        display_name = data.azuread_group.idpay_adgroup_domain_admin.display_name
      },
      {
        object_id    = data.azuread_group.mdc_adgroup_domain_admin.object_id
        display_name = data.azuread_group.mdc_adgroup_domain_admin.display_name
      },
    ] : []
  ])
}
