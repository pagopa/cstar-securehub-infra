data "external" "terrasops" {
  for_each = toset(local.secrets_folders_kv)

  program = [
    "bash", "terrasops.sh"
  ]
  query = {
    path = "secrets/${each.key}/${var.location_short}-${var.env}"
  }
  # Example output for each instance:
  # key: "core" =>
  #   result = { "secret1" = "encValue1", "secret2" = "encValue2" }
  # key: "cicd" =>
  #   result = { "secretA" = "encValueA" }
}

locals {
  # all_enc_secrets_value groups secrets by key vault.
  # Example output:
  # {
  #   "core" = [
  #     { sec_key = "secret1", sec_val = "encValue1" },
  #     { sec_key = "secret2", sec_val = "encValue2" }
  #   ],
  #   "cicd" = [
  #     { sec_key = "secretA", sec_val = "encValueA" }
  #   ]
  # }
  all_enc_secrets_value = {
    for key, ext in data.external.terrasops :
    key => can(ext.result) ? [
      for k, v in ext.result : {
        sec_val = v
        sec_key = k
      }
    ] : []
  }

  # Create a flattened list of secrets adding the key vault name.
  # Example output:
  # [
  #   { sec_key = "secret1", sec_val = "encValue1", key_vault = "core" },
  #   { sec_key = "secret2", sec_val = "encValue2", key_vault = "core" },
  #   { sec_key = "secretA", sec_val = "encValueA", key_vault = "cicd" }
  # ]
  secrets_flat = flatten([
    for vault, secrets in local.all_enc_secrets_value : [
      for s in secrets : merge(s, { key_vault = vault })
    ]
  ])
}

## SOPS secrets

## Upload all encrypted secrets
resource "azurerm_key_vault_secret" "sops_local_secrets" {
  # Iterate over the flat list with a unique key "vault-secret"
  # Example: { for_each = {
  #   "core-secret1" = { sec_key = "secret1", sec_val = "encValue1", key_vault = "core" },
  #   "cicd-secretA" = { sec_key = "secretA", sec_val = "encValueA", key_vault = "cicd" },
  #   ... } }
  for_each = { for s in local.secrets_flat : "${s.key_vault}-${s.sec_key}" => s }

  # Assuming module.key_vault is mapped per key vault (e.g., module.key_vault["core"] and module.key_vault["cicd"])
  key_vault_id = module.key_vault[each.value.key_vault].id
  name         = each.value.sec_key
  value        = each.value.sec_val

  depends_on = [
    module.key_vault,
  ]
}
