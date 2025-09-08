locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}" // e.g. "cstar-d-itn-core"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"               // e.g. "cstar-d-itn
  product          = "${var.prefix}-${var.env_short}"                                     // e.g. "cstar-d-itn"

  prefix_key_vaults = ["core", "cicd"] // e.g. ["core", "cicd"]
}
