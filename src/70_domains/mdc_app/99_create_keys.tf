locals {
  # Mappa delle chiavi divisa per ambiente (d, u, p)
  keys_map = {
    "d" = [
      "c0c50d74-c83d-4ef4-978a-6c1901e4b5db-1732208114820",
      "62c33e91-0584-4038-9e66-9d1ff8114368-1744118376085",
      "be46399d-23e4-43d9-b2b8-41c8fd5f5e40-1732202076421"
    ],
    "u" = [
      "b9556bad-7c16-4378-9a9a-171388d8fa60-1733500774676",
      "f6ce4e69-fa75-4ff5-b87e-a4219a74977d-1733497355446",
      "e441825b-ddf2-4067-9b00-33a74aa1bba0-1744118452678"
    ],
    "p" = [
      "2d59ed62-c05c-414d-a80d-3823f011c837-1743427060887",
      "bc1c40d0-f421-424f-bfd2-72246100811f-1751987878630",
      "cdd6dced-072f-417d-a905-bf6e7b2509cb-1758014997678"
    ]
  }

  # Seleziona la lista corretta in base alla variabile d'ambiente (d, u, p)
  # Usa lookup per evitare crash se l'env non è in lista (ritorna lista vuota)
  selected_keys = lookup(local.keys_map, var.env_short, [])
}

# 1. Recupera il Key Vault usando le variabili esistenti per costruire il nome
data "azurerm_key_vault" "target_kv" {
  name                = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-kv"
  resource_group_name = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}-security-rg"
}

# 2. Crea le chiavi dinamicamente
resource "azurerm_key_vault_key" "keys" {
  for_each = toset(local.selected_keys)

  name         = each.value
  key_vault_id = data.azurerm_key_vault.target_kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}