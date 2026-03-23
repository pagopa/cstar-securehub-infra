module "secrets" {
  source = "./.terraform/modules/__v4__/key_vault_secrets_query"

  key_vault_name = local.kv_domain_name
  resource_group = local.kv_domain_rg_name

  secrets = compact([
    "email-mdc-slack",
    "email-mdc-google"
  ])
}
