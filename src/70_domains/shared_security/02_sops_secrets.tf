data "external" "terrasops" {
  for_each = toset([var.domain])

  program = [
    "bash", "terrasops.sh"
  ]
  query = {
    path = local.input_file
  }
}

locals {
  all_enc_secrets_value = {
    for key, ext in data.external.terrasops :
    key => can(ext.result) ? [
      for k, v in ext.result : {
        sec_val = v
        sec_key = k
      }
    ] : []
  }
  secrets_flat = flatten([
    for vault, secrets in local.all_enc_secrets_value : [
      for s in secrets : merge(s, { key_vault = vault })
    ]
  ])
}

## SOPS secrets

## Upload all encrypted secrets
resource "azurerm_key_vault_secret" "sops_local_secrets" {
  for_each = { for s in local.secrets_flat : s.sec_key => s }

  key_vault_id = module.key_vault.id
  name         = each.value.sec_key
  value        = each.value.sec_val

  tags = merge(
    module.tag_config.tags,
    {
      "SOPS" = true
    }
  )

  depends_on = [
    module.key_vault,
  ]
}
