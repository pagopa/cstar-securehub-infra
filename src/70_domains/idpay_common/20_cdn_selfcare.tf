module "cdn_idpay_selfcare" {

  source = "./.terraform/modules/__v4__/cdn"
  # source              = "git::https://github.com/pagopa/terraform-azurerm-v4.git//cdn?ref=cdn-added-outputs"
  name                = "selfcare"
  prefix              = local.project_weu
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location
  cdn_location        = var.location_weu

  hostname              = "selfcare-italy.${data.azurerm_dns_zone.public_cstar.name}"
  https_rewrite_enabled = true

  storage_account_name             = "${local.project}selcdnsa"
  storage_account_replication_type = var.selfcare_welfare_cdn_storage_account_replication_type
  index_document                   = "index.html"
  error_404_document               = "not_found.html"

  dns_zone_name                = data.azurerm_dns_zone.public_cstar.name
  dns_zone_resource_group_name = data.azurerm_dns_zone.public_cstar.resource_group_name

  keyvault_resource_group_name = local.idpay_kv_rg_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id
  keyvault_vault_name          = local.idpay_kv_name

  querystring_caching_behaviour      = "BypassCaching"
  advanced_threat_protection_enabled = var.idpay_cdn_sa_advanced_threat_protection_enabled

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics.id


  // https://antbutcher.medium.com/hosting-a-react-js-app-on-azure-blob-storage-azure-cdn-for-ssl-and-routing-8fdf4a48feeb
  // it is important to add base tag in index.html too (i.e. <base href="/">)
  delivery_rule_rewrite = [{
    name  = "RewriteRules"
    order = 2

    conditions = [{
      condition_type   = "url_file_extension_condition"
      operator         = "LessThan"
      match_values     = ["1"]
      transforms       = []
      negate_condition = false
    }]

    url_rewrite_action = {
      source_pattern          = "/"
      destination             = "/index.html"
      preserve_unmatched_path = false
    }
  }]

  global_delivery_rule = {
    cache_expiration_action       = []
    cache_key_query_string_action = []
    modify_request_header_action  = []

    # HSTS
    modify_response_header_action = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
    ]
  }

  tags = var.tags
}

locals {
  selfcare-issuer = "https://${var.env != "prod" ? "${var.env}." : ""}selfcare-italy.pagopa.it"
}

resource "azurerm_storage_blob" "oidc_configuration" {
  name                   = "selfcare/openid-configuration.json"
  storage_account_name   = module.cdn_idpay_selfcare.storage_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/json"
  access_tier            = "Hot"

  source_content = templatefile("./cdn/openid-configuration.json.tpl", {
    selfcare-issuer = local.selfcare-issuer
  })

  depends_on = [
    module.cdn_idpay_selfcare
  ]
}
