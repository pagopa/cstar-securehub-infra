data "azurerm_resource_group" "identity_rg" {
  name = "${local.product}-identity-rg"
}


# repos must be lower than 20 items
locals {
  repos_01 = concat(
    [],
    var.env_short == "p" ? [] : [
      "idpay-functional-testing"
    ]
  )

  federations_01 = [
    for repo in local.repos_01 : {
      repository = repo
      subject    = var.env
    }
  ]

  environment_cd_roles = {
    resource_groups = {
      "${local.idpay_kv_rg_name}" = [
        "Key Vault Reader"
      ]
    }
  }
}

module "identity_cd_01" {
  source = "./.terraform/modules/__v4__/github_federated_identity"

  prefix    = var.prefix
  env_short = var.env_short
  domain    = "${var.domain}-01"

  identity_role = "cd"

  github_federations = local.federations_01

  cd_rbac_roles = {
    subscription_roles = []
    resource_groups    = local.environment_cd_roles.resource_groups
  }

  tags = module.tag_config.tags

  depends_on = [
    data.azurerm_resource_group.identity_rg
  ]
}

resource "azurerm_key_vault_access_policy" "gha_iac_managed_identities" {
  key_vault_id = data.azurerm_key_vault.key_vault_domain.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.identity_cd_01.identity_principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  certificate_permissions = [
    "Get",
    "List"
  ]

  key_permissions = [
    "Get",
    "List"
  ]

  storage_permissions = []
}
