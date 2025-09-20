data "external" "terrasops" {
  program = [
    "bash", "terrasops.sh"
  ]

  query = {
    path = local.secrets_base_path
  }
}

locals {
  encrypted_secrets = can(data.external.terrasops.result) ? [
    for key, value in data.external.terrasops.result : {
      key     = key
      value   = value
      is_sops = true
    }
  ] : []

  config_secret_data = jsondecode(file(local.config_input_file))
  config_secrets = [
    for key, value in local.config_secret_data : {
      key     = key
      value   = value
      is_sops = false
    }
  ]

  all_secrets = concat(local.config_secrets, local.encrypted_secrets)
}

resource "azurerm_key_vault_secret" "core" {
  for_each = { for secret in local.all_secrets : secret.key => secret }

  key_vault_id = module.key_vault["core"].id
  name         = each.value.key
  value        = each.value.value

  tags = merge(
    local.tags,
    each.value.is_sops ? { SOPS = "True" } : {}
  )

  depends_on = [
    module.key_vault,
    azurerm_key_vault_key.sops,
    data.external.terrasops,
  ]
}
