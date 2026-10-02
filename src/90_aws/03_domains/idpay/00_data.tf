# KV Domain
data "azurerm_key_vault" "kv_idpay" {
  name                = "${local.product}-${var.location_short}-${var.domain}-kv"
  resource_group_name = "${local.product}-${var.location_short}-${var.domain}-security-rg"
}

data "terraform_remote_state" "core" {
  backend = "s3"

  config = {
    bucket  = var.core_state_bucket
    key     = "02_core.tfstate"
    region  = var.aws_region
    profile = var.aws_profile
  }
}
