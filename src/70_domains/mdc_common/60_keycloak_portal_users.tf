# Utenze locali del portale interno, create esclusivamente in UAT.
# Le credenziali sono gestite in Key Vault e gia' caricate da 00_secrets.tf.
locals {
  mdc_portal_uat_users = var.env_short == "u" ? {
    admin = {
      username = module.secrets.values["mdc-bo-int-admin-username"].value
      password = module.secrets.values["mdc-bo-int-admin-password"].value
      email      = "mdc-portal-uat-admin@example.invalid"
      first_name = "MDC"
      last_name  = "Portal Admin"
      role_id    = keycloak_role.portal_operator_admin.id
    }
    write = {
      username = module.secrets.values["mdc-bo-int-write-username"].value
      password = module.secrets.values["mdc-bo-int-write-password"].value
      email      = "mdc-portal-uat-write@example.invalid"
      first_name = "MDC"
      last_name  = "Portal Write"
      role_id    = keycloak_role.portal_operator_write.id
    }
    read = {
      username = module.secrets.values["mdc-bo-int-read-username"].value
      password = module.secrets.values["mdc-bo-int-read-password"].value
      email      = "mdc-portal-uat-read@example.invalid"
      first_name = "MDC"
      last_name  = "Portal Read"
      role_id    = keycloak_role.portal_operator_read.id
    }
  } : {}
}

# `initial_password` del provider viene applicata solo durante la creazione
# dell'utente. L'hash consente di rilevare una variazione del secret senza
# salvarne il valore come trigger esplicito.
resource "terraform_data" "mdc_portal_uat_password" {
  for_each = local.mdc_portal_uat_users

  input = sha256(each.value["password"])
}

resource "keycloak_user" "mdc_portal_uat" {
  for_each = local.mdc_portal_uat_users

  realm_id = local.keycloak_realm_id
  username = each.value["username"]
  enabled  = true

  lifecycle {
    replace_triggered_by = [
      terraform_data.mdc_portal_uat_password[each.key]
    ]
  }

  email          = each.value["email"]
  email_verified = true
  first_name     = each.value["first_name"]
  last_name      = each.value["last_name"]

  initial_password {
    value     = each.value["password"]
    temporary = false
  }
}

# Assegna il ruolo massimo del profilo: i ruoli compositi ereditano i permessi
# inferiori (admin -> write -> read).
resource "keycloak_user_roles" "mdc_portal_uat" {
  for_each = local.mdc_portal_uat_users

  realm_id = local.keycloak_realm_id
  user_id  = keycloak_user.mdc_portal_uat[each.key].id
  role_ids = [each.value["role_id"]]
}
