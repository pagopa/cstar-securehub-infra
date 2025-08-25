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

  # DNS Zone Reference for the main CDN
  bonus_dns_zone = data.azurerm_dns_zone.bonus_elettrodomestici_apex[local.dns_zone_key]

  # All bonus elettrodomestici zones apex
  all_bonus_zones_apex = data.azurerm_dns_zone.bonus_elettrodomestici_apex

  custom_domains = [for z in local.all_bonus_zones_apex : {
    domain_name                 = z.name
    dns_name                    = z.name
    dns_resource_group_name  = z.resource_group_name
    ttl                         = var.env != "p" ? 300 : 3600
  }]

  # Security Headers - Applied globally to all responses
  # These headers enhance security by preventing common attacks
  security_headers_part1 = [
    {
      action = "Overwrite"
      name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
      value  = "default-src 'self'; object-src 'none'; connect-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ https://api-eu.mixpanel.com/track/ https://${var.mcshared_dns_zone_prefix}.${var.prefix}.${var.external_domain}/; "
    },
    {
      action = "Append"
      name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
      value  = "script-src 'self'; style-src 'self' 'unsafe-inline' https://selfcare${local.selfare_temp_suffix}.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://selfcare${local.selfare_temp_suffix}.pagopa.it/assets/font/; "
    },
    {
      action = "Append"
      name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
      value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_bonuselettrodomestici.storage_primary_web_host}; "
    },
  ]

  security_headers_part2 = [
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

  # Application Delivery Rules - URL Rewrite Rules
  # These rules handle routing for different frontend applications
  # by rewriting URLs to serve the correct index.html files
  app_delivery_rules = concat([
    # Cittadino Application Rule - Handles citizen portal routing
    {
      name  = "CittadinoApplication"
      order = 10
      conditions = [
        {
          condition_type   = "url_path_condition"
          operator         = "BeginsWith"
          match_values     = ["/utente"]
          negate_condition = false
          transforms       = null
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "LessThanOrEqual"
          match_values     = ["0"]
          negate_condition = false
          transforms       = []
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "BeginsWith"
          match_values     = ["/utente/assets"]
          negate_condition = true
          transforms       = []
        }
      ]
      url_rewrite_action = {
        source_pattern          = "/utente"
        destination             = "/utente/index.html"
        preserve_unmatched_path = false
      }
    },
    # Esercenti Application Rule - Handles merchant portal routing
    {
      name  = "PortaleEsercentiApplication"
      order = 11
      conditions = [
        {
          condition_type   = "url_path_condition"
          operator         = "BeginsWith"
          match_values     = ["/esercente"]
          negate_condition = false
          transforms       = null
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "LessThanOrEqual"
          match_values     = ["0"]
          negate_condition = false
          transforms       = []
        },
        {
          condition_type   = "url_path_condition"
          operator         = "BeginsWith"
          match_values     = ["/esercente/assets"]
          negate_condition = true
          transforms       = []
        }
      ]
      url_rewrite_action = {
        source_pattern          = "/esercente"
        destination             = "/esercente/index.html"
        preserve_unmatched_path = false
      }
    }
    ],
  )

  # Calculate the total number of rewrite rules for subsequent order calculations
  total_rewrite_rules = length(local.app_delivery_rules)

  # Additional Delivery Rules - Non-rewrite rules (redirects, headers, caching)
  additional_delivery_rules = [
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
    {
      name  = "RootRedirect"
      order = 20 + local.total_rewrite_rules + 4

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
}

// Public CDN to serve frontend - main domain
module "cdn_idpay_bonuselettrodomestici" {
  # source = "./.terraform/modules/__v4__/cdn"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//cdn_frontdoor?ref=PAYMCLOUD-477-v-4-creazione-modulo-cdn-front-door-per-sostituire-cdn-classic-deprecata"

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
  tenant_id = data.azurerm_client_config.current.tenant_id

  # Caching Configuration
  querystring_caching_behaviour = "IgnoreQueryString"
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.core_log_analytics.id

  # Global Delivery Rules
  global_delivery_rules = [
    {
      order                         = 1
      modify_response_header_action = local.security_headers_part1
    },
    {
      order                         = 2
      modify_response_header_action = local.security_headers_part2
  }]

  # Application-specific Delivery Rules (rewrite only)
  delivery_rule_rewrite = local.app_delivery_rules

  # Generic Delivery Rules (including redirects)
  delivery_rule = local.additional_delivery_rules

  # Domain Configuration
  custom_domains = local.custom_domains

  tags = module.tag_config.tags
}

# /**
#  * DNS Records for all bonus elettrodomestici apex zones
#  * Includes: .it, .com, .info, .io, .net, .eu, pagopa.it
#  */
#
# # A Record for APEX domain for ALL bonus elettrodomestici zones
# resource "azurerm_dns_a_record" "bonus_all_zones_apex" {
#   for_each = local.all_bonus_zones_apex
#
#   name                = "@"
#   zone_name           = each.value.name
#   resource_group_name = each.value.resource_group_name
#   ttl                 = 300
#   target_resource_id  = module.cdn_idpay_bonuselettrodomestici.id
#
#   tags = module.tag_config.tags
# }
#
# # CNAME cdnverify record for ALL bonus elettrodomestici zones
# resource "azurerm_dns_cname_record" "bonus_all_zones_cdnverify" {
#   for_each = local.all_bonus_zones_apex
#
#   name                = "cdnverify"
#   zone_name           = each.value.name
#   resource_group_name = each.value.resource_group_name
#   ttl                 = 300
#   record              = "cdnverify.${module.cdn_idpay_bonuselettrodomestici.hostname}"
#
#   tags = module.tag_config.tags
# }
#
# /**
#  * Custom Domain Configuration for Azure CDN (Classic)
#  * Associates all bonus elettrodomestici domains to the CDN endpoint
#  * Note: Using azurerm_cdn_endpoint_custom_domain for Azure CDN Classic
#  */
#
# # Custom Domain for each bonus elettrodomestici zone apex - Azure CDN Classic
# resource "azurerm_cdn_endpoint_custom_domain" "bonus_custom_domains" {
#   for_each = local.all_bonus_zones_apex
#
#   name            = replace(replace(each.key, ".", "-"), "_", "-")
#   cdn_endpoint_id = module.cdn_idpay_bonuselettrodomestici.id
#   host_name       = each.value.name
#
#   # Enable HTTPS with CDN user defined certificate
#   user_managed_https {
#     key_vault_secret_id = data.azurerm_key_vault_certificate.bonus_elettrodomestici_cert_apex[
#       join("-", split(".", each.key))
#     ].versionless_secret_id
#     tls_version = "TLS12"
#   }
#
#   # Depends on DNS records for domain verification
#   depends_on = [
#     azurerm_dns_a_record.bonus_all_zones_apex,
#     azurerm_dns_cname_record.bonus_all_zones_cdnverify
#   ]
# }
#
# data "azuread_service_principal" "microsoft_cdn" {
#   display_name = "Microsoft.AzureFrontDoor-Cdn"
# }
#
# resource "azurerm_key_vault_access_policy" "cdn_certificates_policy" {
#   key_vault_id = data.azurerm_key_vault.domain_kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = data.azuread_service_principal.microsoft_cdn.object_id
#
#   certificate_permissions = [
#     "Get",
#     "List"
#   ]
#
#   secret_permissions = [
#     "Get",
#     "List"
#   ]
# }
