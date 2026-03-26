# Realm configuration for Keycloak
resource "keycloak_realm" "mdc" {
  realm        = "mdc"
  enabled      = true
  display_name = "Messaggi di cortesia"

  internationalization {
    supported_locales = [
      "it"
    ]
    default_locale = "it"
  }

  # Durata dei token (opzionale)
  access_token_lifespan = "30m"

}
