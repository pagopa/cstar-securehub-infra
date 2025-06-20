
# See https://github.com/keycloak/terraform-provider-keycloak/blob/main/example/main.tf
resource "keycloak_realm" "test" {
  realm             = "test"
  enabled           = true
  display_name      = "foo"
  display_name_html = "<b>foo</b>"

  smtp_server {
    host                  = "mysmtphost.com"
    port                  = 25
    from_display_name     = "Tom"
    from                  = "tom@myhost.com"
    reply_to_display_name = "Tom"
    reply_to              = "tom@myhost.com"
    ssl                   = true
    starttls              = true
    envelope_from         = "nottom@myhost.com"

    auth {
      username = "tom"
      password = "tom"
    }
  }

  account_theme        = "base"
  access_code_lifespan = "30m"

  internationalization {
    supported_locales = [
      "en",
      "de",
      "es",
    ]

    default_locale = "en"
  }



  ssl_required    = "external"
  password_policy = "upperCase(1) and length(8) and forceExpiredPasswordChange(365) and notUsername"

  attributes = {
    mycustomAttribute  = "myCustomValue"
    userProfileEnabled = true
  }

  web_authn_policy {
    relying_party_entity_name = "Example"
    relying_party_id          = "keycloak.example.com"
    signature_algorithms = [
      "ES256",
      "RS256"
    ]
  }

  web_authn_passwordless_policy {
    relying_party_entity_name = "Example"
    relying_party_id          = "keycloak.example.com"
    signature_algorithms = [
      "ES256",
      "RS256"
    ]
  }
}
