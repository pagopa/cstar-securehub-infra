/**
 * CDN
 */

locals {
  # CDN Configuration Constants
  cdn_storage_account_name = "${local.project}bonuscdnsa"
  cdn_index_document       = "index.html"
  cdn_error_document       = "error.html"

  # DNS Zone Key for the main CDN (the one configured in the module)
  dns_zone_key = var.env_short != "p" ? "${var.env}.bonuselettrodomestici.it" : "bonuselettrodomestici.it"

  # All bonus elettrodomestici zones apex
  all_bonus_zones_apex = data.azurerm_dns_zone.bonus_elettrodomestici_apex

  custom_domains = [for z in local.all_bonus_zones_apex : {
    domain_name             = z.name
    dns_name                = z.name
    dns_resource_group_name = z.resource_group_name
    ttl                     = var.env != "p" ? 300 : 3600
  }]

  #--------------------------------------------------
  # ⚠️ Redirect Rules - Handles root URL redirection to main domain
  #--------------------------------------------------
  bonus_redirect_urls = [
    {
      name              = "RootRedirect"
      order             = 0
      behavior_on_match = "Stop"

      // conditions
      url_path_conditions = [
        {
          operator         = "Equal"
          match_values     = ["/"]
          negate_condition = false
          transforms       = null
        }
      ]

      // actions
      url_redirect_actions = [
        {
          redirect_type = "Found"
          protocol      = "Https"
          hostname      = "ioapp.it"
          path          = "/"
          fragment      = ""
          query_string  = ""
        }
      ]
    }
  ]

  # Security Headers - Applied globally to all responses
  # These headers enhance security by preventing common attacks
  global_delivery_rules = [
    {
      order = 1
      modify_response_header_actions = [
        {
          action = "Overwrite"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "default-src 'self'; object-src 'none'; frame-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ ${local.mcshared_api_url}/; connect-src 'self' https://selfcare.pagopa.it https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ ${local.mcshared_api_url}/ https://api-eu.mixpanel.com/track/;"
        },
        {
          action = "Append"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline' https://${local.selfare_subdomain}.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://${local.selfare_subdomain}.pagopa.it/assets/font/;"
        },
        {
          action = "Append"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_bonuselettrodomestici.storage_primary_web_host};"
        }
      ]
    },
    {
      order = 2
      modify_response_header_actions = [
        {
          action = "Overwrite"
          name   = "Strict-Transport-Security"
          value  = "max-age=31536000"
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
  }]

  # Application Delivery Rules - URL Rewrite Rules
  # These rules handle routing for different frontend applications
  # by rewriting URLs to serve the correct index.html files
  app_delivery_rules = concat([
    # Cittadino Application Rule - Handles citizen portal routing
    {
      name  = "RewriteUtenteCittadinoApplication"
      order = 10

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/utente/assets"]
          negate_condition = true
          transforms       = null
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/utente"]
          negate_condition = false
          transforms       = null
        }
      ]

      url_file_extension_conditions = [{
        operator         = "LessThanOrEqual"
        match_values     = ["0"]
        negate_condition = false
        transforms       = []
      }]

      url_rewrite_actions = [{
        source_pattern          = "/utente"
        destination             = "/utente/index.html"
        preserve_unmatched_path = false
      }]
    },
    # Esercenti Application Rule - Handles merchant portal routing
    {
      name  = "RewritePortaleEsercentiApplication"
      order = 15

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/esercente/assets"]
          negate_condition = true
          transforms       = []
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/esercente"]
          negate_condition = false
          transforms       = null
        }
      ]

      url_file_extension_conditions = [{
        operator         = "LessThanOrEqual"
        match_values     = ["0"]
        negate_condition = false
        transforms       = []
      }]

      url_rewrite_actions = [{
        source_pattern          = "/esercente"
        destination             = "/esercente/index.html"
        preserve_unmatched_path = false
      }]
    }
    ],
  )

  # Calculate the total number of rewrite rules for subsequent order calculations
  total_rewrite_rules = length(local.app_delivery_rules)

  # Additional Delivery Rules - Non-rewrite rules (redirects, headers, caching)
  delivery_custom_rules = [
    {
      name  = "robotsNoIndex"
      order = 20 + local.total_rewrite_rules + 2

      // conditions
      url_path_conditions = [
        {
          operator         = "Equal"
          match_values     = try(length(var.robots_indexed_paths) > 0 ? var.robots_indexed_paths : ["dummy"], ["dummy"])
          negate_condition = true
          transforms       = null
        }
      ]

      // actions
      modify_response_header_actions = [
        {
          action = "Overwrite"
          name   = "X-Robots-Tag"
          value  = "noindex, nofollow"
        }
      ]
    },
    {
      name  = "microcomponentsNoCache"
      order = 20 + local.total_rewrite_rules + 3

      // conditions

      url_file_name_conditions = [
        {
          operator         = "Equal"
          match_values     = ["remoteEntry.js"]
          negate_condition = false
          transforms       = null
        }
      ]

      // actions
      modify_response_header_actions = [
        {
          action = "Overwrite"
          name   = "Cache-Control"
          value  = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
        }
      ]
    },
  ]
}

// Public CDN to serve frontend - main domain
module "cdn_idpay_bonuselettrodomestici" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor"

  # Basic Configuration
  cdn_prefix_name     = "${local.project}-bonus"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location

  # Storage Configuration
  storage_account_name               = local.cdn_storage_account_name
  storage_account_replication_type   = var.idpay_cdn_storage_account_replication_type
  storage_account_index_document     = local.cdn_index_document
  storage_account_error_404_document = local.cdn_error_document

  # Key Vault Configuration
  keyvault_id = data.azurerm_key_vault.domain_kv.id
  tenant_id   = data.azurerm_client_config.current.tenant_id

  # Caching Configuration
  querystring_caching_behaviour = "IgnoreQueryString"
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.core_log_analytics.id

  delivery_rule_redirects = local.bonus_redirect_urls

  # Global Delivery Rules
  global_delivery_rules = local.global_delivery_rules

  # Application-specific Delivery Rules (rewrite only)
  delivery_rule_rewrites = local.app_delivery_rules

  # Generic Delivery Rules (including redirects)
  delivery_custom_rules = local.delivery_custom_rules

  # Domain Configuration
  custom_domains = local.custom_domains

  tags = module.tag_config.tags
}
