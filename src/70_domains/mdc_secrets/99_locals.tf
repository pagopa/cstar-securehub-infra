locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  project_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"
  product          = "${var.prefix}-${var.env_short}"

  # this are the folder names inside the secrets folder in idpay_security
  secrets_folders_kv = ["mdc"] // e.g. ["core", "cicd"]
}
