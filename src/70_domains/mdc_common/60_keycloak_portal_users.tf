# Utenze locali del portale interno, create esclusivamente in UAT.
# Le credenziali sono gestite in Key Vault e gia' caricate da 00_secrets.tf.
locals {
  mdc_portal_uat_users = var.env_short == "u" ? {
    admin = {
      username = module.secrets.values["mdc-bo-int-admin-username"].value
      password = module.secrets.values["mdc-bo-int-admin-password"].value
      role_id  = keycloak_role.portal_operator_admin.id
    }
    write = {
      username = module.secrets.values["mdc-bo-int-write-username"].value
      password = module.secrets.values["mdc-bo-int-write-password"].value
      role_id  = keycloak_role.portal_operator_write.id
    }
    read = {
      username = module.secrets.values["mdc-bo-int-read-username"].value
      password = module.secrets.values["mdc-bo-int-read-password"].value
      role_id  = keycloak_role.portal_operator_read.id
    }
  } : {}
}

resource "keycloak_user" "mdc_portal_uat" {
  for_each = local.mdc_portal_uat_users

  realm_id = local.keycloak_realm_id
  username = each.value.username
  enabled  = true

  initial_password {
    value     = each.value.password
    temporary = false
  }
}

# Assegna il ruolo massimo del profilo: i ruoli compositi ereditano i permessi
# inferiori (admin -> write -> read).
resource "keycloak_user_roles" "mdc_portal_uat" {
  for_each = local.mdc_portal_uat_users

  realm_id = local.keycloak_realm_id
  user_id  = keycloak_user.mdc_portal_uat[each.key].id
  role_ids = [each.value.role_id]
}
