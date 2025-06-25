
# See https://github.com/keycloak/terraform-provider-keycloak/blob/main/example/main.tf
resource "keycloak_realm" "merchant-operator" {
  realm            = "merchant-operator"
  enabled          = true
  display_name     = "merchant-operator"
}
