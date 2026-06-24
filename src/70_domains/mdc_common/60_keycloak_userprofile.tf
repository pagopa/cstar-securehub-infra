# Manages the User Profile configuration for the MDC realm.
# IMPORTANT: This resource manages the ENTIRE user profile, so ALL attributes
# (including Keycloak built-ins) must be declared here to avoid unintended deletion.
resource "keycloak_realm_user_profile" "mdc" {
  realm_id = local.keycloak_realm_id

  # ── Built-in Keycloak attributes ──────────────────────────────────────────

  attribute {
    name         = "username"
    display_name = "$${username}"

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        min = "3"
        max = "255"
      }
    }
    validator {
      name = "username-prohibited-characters"
    }
    validator {
      name = "up-username-not-idn-homograph"
    }
  }

  attribute {
    name         = "email"
    display_name = "$${email}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "email"
    }
    validator {
      name = "length"
      config = {
        max = "255"
      }
    }
  }

  attribute {
    name         = "firstName"
    display_name = "$${firstName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = "255"
      }
    }
    validator {
      name = "person-name-prohibited-characters"
    }
  }

  attribute {
    name         = "lastName"
    display_name = "$${lastName}"

    required_for_roles = ["user"]

    permissions {
      view = ["admin", "user"]
      edit = ["admin", "user"]
    }

    validator {
      name = "length"
      config = {
        max = "255"
      }
    }
    validator {
      name = "person-name-prohibited-characters"
    }
  }

  # ── Custom attributes ──────────────────────────────────────────────────────

  attribute {
    name         = "orgId"
    display_name = "Org ID"

    permissions {
      view = ["admin", "user"]
      edit = ["admin"]
    }

    validator {
      name = "length"
      config = {
        max = "255"
      }
    }
  }

  attribute {
    name         = "orgRoles"
    display_name = "Org Roles"
    multi_valued = true

    permissions {
      view = ["admin", "user"]
      edit = ["admin"]
    }
  }

  attribute {
    name         = "orgFiscalCode"
    display_name = "Org Fiscal Code"

    permissions {
      view = ["admin", "user"]
      edit = ["admin"]
    }

    validator {
      name = "length"
      config = {
        max = "255"
      }
    }
  }
}
