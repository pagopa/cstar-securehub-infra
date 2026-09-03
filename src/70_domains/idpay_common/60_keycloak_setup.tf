##################
# Realms: User + Merchant Operator
##################

moved {
  from = keycloak_realm.user
  to   = module.keycloak_setup.keycloak_realm.this["user"]
}

moved {
  from = keycloak_realm.merchant_operator
  to   = module.keycloak_setup.keycloak_realm.this["merchant-operator"]
}

module "keycloak_setup" {
  source = "./.terraform/modules/__v4__/keycloak_realms_setup"

  domain = var.domain

  realms_configuration = [
    {
      name                     = "user",
      display_name             = "user"
      description              = "User Realm"
      enabled                  = true
      duplicate_emails_allowed = true
      attributes = {
        frontendUrl = local.keycloak_external_hostname
      }
    },
    {
      name         = "merchant-operator",
      display_name = "merchant-operator"
      description  = "Merchant Operator Realm"
      enabled      = true
      login_theme  = "pagopa"
      email_theme  = "pagopa"

      # Password policy applied on first-time password set (executeActionsEmail -> UPDATE_PASSWORD)
      # and on any subsequent password change.
      # Rules: length 10-64, at least 1 lowercase, 1 uppercase, 1 digit, 1 special char.
      # Only enforced in prod and uat; dev has no password constraints.
      password_policy = contains(["p", "u"], var.env_short) ? "length(10) and maxLength(64) and lowerCase(1) and upperCase(1) and digits(1) and specialChars(1)" : null

      attributes = {
        frontendUrl = local.keycloak_external_hostname
      }
      internationalization = {
        supported_locales = [
          "it"
        ]
        default_locale = "it"
      }

      smtp_server = {
        host              = data.azurerm_key_vault_secret.ses_smtp_host.value
        port              = local.ses_smtp_port
        from              = data.azurerm_key_vault_secret.ses_from_address.value
        ssl               = true
        from_display_name = "Portale Bonus Elettrodomestici"

        auth = {
          username = data.azurerm_key_vault_secret.ses_smtp_username.value
          password = data.azurerm_key_vault_secret.ses_smtp_password.value
        }
      }
    }
  ]

  key_vault_rg   = local.idpay_kv_rg_name
  key_vault_name = data.azurerm_key_vault.domain_kv.name

  admin_entra_group_ids = concat(
    var.env_short != "p" ? [data.azuread_group.adgroup_domain_externals.object_id, data.azuread_group.adgroup_domain_developers.object_id] : [],
    [
      data.azuread_group.adgroup_domain_admin.object_id
    ]
  )

  viewer_entra_group_ids = [
    data.azuread_group.adgroup_domain_project_managers.object_id
  ]
  tags = module.tag_config.tags
}
