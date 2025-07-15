module "cdn" {
  source = "./.terraform/modules/__v4__/cdn"
  count  = var.enable_cdn ? 1 : 0

  name                = "fe"
  prefix              = local.project
  resource_group_name = local.data_rg_name
  location            = var.location
  cdn_location        = var.cdn_location

  hostname                     = "rtp.${local.dns_zone_name}"
  dns_zone_name                = local.dns_zone_name
  dns_zone_resource_group_name = local.vnet_legacy_core_rg

  storage_account_replication_type = "ZRS"

  https_rewrite_enabled      = true
  index_document             = "index.html"
  error_404_document         = "error_404.html"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tenant_id                                        = data.azurerm_key_vault.domain_kv.tenant_id
  keyvault_resource_group_name                     = data.azurerm_key_vault.domain_kv.resource_group_name
  azuread_service_principal_azure_cdn_frontdoor_id = var.azuread_service_principal_azure_cdn_frontdoor_id
  keyvault_subscription_id                         = data.azurerm_key_vault.domain_kv.tenant_id
  keyvault_vault_name                              = data.azurerm_key_vault.domain_kv.name

  delivery_rule_rewrite = [{
    name  = "RewriteRulesForReactRouting"
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
    modify_response_header_action = [
      {
        action = "Overwrite"
        name   = "Strict-Transport-Security"
        value  = "max-age=31536000"
      },
      # To be reviewed with the front-end team when this CDN is deployed to UAT and PROD.
      {
        action = "Append"
        name   = contains(["d", "u"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "default-src 'self'; object-src 'none'; style-src 'self'; connect-src 'self' https://api-rtp.${local.dns_zone_name}/ ; "
      },
      {
        action = "Append"
        name   = "X-Content-Type-Options"
        value  = "nosniff"
      },
      {
        action = "Overwrite"
        name   = "X-Frame-Options"
        value  = "SAMEORIGIN"
      }
    ]
  }
  tags = module.tag_config.tags
}
