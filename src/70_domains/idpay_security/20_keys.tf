resource "azurerm_key_vault_key" "idpay_mil_key" {
  name         = "idpay-mil-key"
  key_vault_id = module.key_vault["idpay"].id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt"
  ]
}
