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
  all_www_bonus_zones = [for z in local.all_bonus_zones_apex : {
    domain_name             = "www.${z.name}"
    dns_name                = z.name
    dns_resource_group_name = z.resource_group_name
    ttl                     = var.env != "p" ? 300 : 3600
  }]

  custom_domains = flatten([[for z in local.all_bonus_zones_apex : {
    domain_name             = z.name
    dns_name                = z.name
    dns_resource_group_name = z.resource_group_name
    ttl                     = var.env != "p" ? 300 : 3600
    }],
    local.all_www_bonus_zones
  ])

  bonus_redirect = flatten([
    [
      {
        name              = "RootRedirect"
        order             = 0
        behavior_on_match = "Stop"

        url_path_conditions = [
          {
            operator         = "Equal"
            match_values     = ["/"]
            negate_condition = false
            transforms       = null
          }
        ]

        url_redirect_actions = [
          {
            redirect_type = "Found"
            protocol      = "Https"
            hostname      = "ioapp.it"
            path          = "/bonus-elettrodomestici"
            fragment      = ""
            query_string  = ""
          }
        ]
      }
    ]
  ])

  #--------------------------------------------------
  # ⚠️ Redirect Rules - Handles root URL redirection to main domain
  #--------------------------------------------------

  # Security Headers - Applied globally to all responses
  # These headers enhance security by preventing common attacks
  global_delivery_rules = [
    {
      order = 1
      modify_response_header_actions = [
        {
          action = "Overwrite"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "default-src 'self'; object-src 'none'; frame-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ ${local.mcshared_api_url}/; connect-src 'self' https://selfcare.pagopa.it https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ ${local.mcshared_api_url}/ https://api-eu.mixpanel.com/track/ https://cdn.cookielaw.org https://privacyportalde-cdn.onetrust.com https://cstar${var.env_short}itnidpayrefundsa.blob.core.windows.net;"
        },
        {
          action = "Append"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "script-src 'self' 'unsafe-inline' https://cdn.cookielaw.org https://privacyportalde-cdn.onetrust.com; style-src 'self' 'unsafe-inline' https://${local.selfare_subdomain}.pagopa.it/assets/font/selfhostedfonts.css https://cdn.cookielaw.org https://privacyportalde-cdn.onetrust.com; worker-src 'none'; font-src 'self' https://${local.selfare_subdomain}.pagopa.it/assets/font/;"
        },
        {
          action = "Append"
          name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
          value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_bonuselettrodomestici.storage_primary_web_host} https://cdn.cookielaw.org https://www.pagopa.it https://selcdcheckoutsa.z6.web.core.windows.net data:;"
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
  app_delivery_rules = flatten([
    # Cittadino Application Rule - Handles citizen portal routing
    [{
      name              = "RewriteUtenteCittadinoApplication"
      order             = 10
      behavior_on_match = "Stop"

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/utente/assets/"]
          negate_condition = true
          transforms       = null
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/utente/"]
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
    }],
    # Esercenti Application Rule - Handles merchant portal routing
    {
      name              = "RewritePortaleEsercentiApplication"
      order             = 15
      behavior_on_match = "Stop"

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/esercente/assets/"]
          negate_condition = true
          transforms       = []
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/esercente/"]
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
    },
    # Elenco informatico elettrodomestici statico Rule - Handles EIE portal routing
    {
      name              = "RewriteEIEStaticApplication"
      order             = 16
      behavior_on_match = "Stop"

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/elenco-informatico-elettrodomestici/assets/"]
          negate_condition = true
          transforms       = []
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/elenco-informatico-elettrodomestici/"]
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
        source_pattern          = "/elenco-informatico-elettrodomestici"
        destination             = "/elenco-informatico-elettrodomestici/index.html"
        preserve_unmatched_path = false
      }]
    },
    # Lista punti vendita statica Rule - Handles Point Of Sales portal routing
    {
      name              = "RewritePOSStaticApplication"
      order             = 17
      behavior_on_match = "Stop"

      url_path_conditions = [
        {
          operator         = "BeginsWith"
          match_values     = ["/lista-punti-vendita/assets/"]
          negate_condition = true
          transforms       = []
        },
        {
          operator         = "BeginsWith"
          match_values     = ["/lista-punti-vendita/"]
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
        source_pattern          = "/lista-punti-vendita"
        destination             = "/lista-punti-vendita/index.html"
        preserve_unmatched_path = false
      }]
    },
  ])

  # Calculate the total number of rewrite rules for subsequent order calculations
  total_rewrite_rules = length(local.app_delivery_rules)

  # Additional Delivery Rules - Non-rewrite rules (redirects, headers, caching)
  delivery_custom_rules = flatten([
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
    [for i in local.public_dns_zone_bonus_elettrodomestici.zones : {
      name              = format("www%s", join("", [for p in split(".", i) : title(p)]))
      order             = 3 + index(local.public_dns_zone_bonus_elettrodomestici.zones, i)
      behavior_on_match = "Stop"

      host_name_condition = [
        {
          operator         = "Equal"
          match_values     = ["www.${i}"]
          negate_condition = false
          transforms       = null
        }
      ]

      url_redirect_actions = [
        {
          redirect_type = "Found"
          protocol      = "Https"
          hostname      = i
          path          = null
          fragment      = null
          query_string  = null
        }
      ]
    }]
  ])

  ## Static content for Bonus Elettrodomestici
  ## Elenco Informatico Elettrodomestici
  upload_eie_files = fileset("${path.module}/cdn/bonus-el-products", "**")
  ## Point of Sales
  upload_pos_files = fileset("${path.module}/cdn/bonus-el-pos", "**")

  content_type_map = {
    ".html"  = "text/html"
    ".htm"   = "text/html"
    ".css"   = "text/css"
    ".js"    = "application/javascript"
    ".mjs"   = "application/javascript"
    ".json"  = "application/json"
    ".map"   = "application/json"
    ".png"   = "image/png"
    ".jpg"   = "image/jpeg"
    ".jpeg"  = "image/jpeg"
    ".gif"   = "image/gif"
    ".svg"   = "image/svg+xml"
    ".ico"   = "image/x-icon"
    ".webp"  = "image/webp"
    ".avif"  = "image/avif"
    ".txt"   = "text/plain"
    ".xml"   = "application/xml"
    ".pdf"   = "application/pdf"
    ".csv"   = "text/csv"
    ".mp4"   = "video/mp4"
    ".webm"  = "video/webm"
    ".ogg"   = "audio/ogg"
    ".mp3"   = "audio/mpeg"
    ".wav"   = "audio/wav"
    ".woff"  = "font/woff"
    ".woff2" = "font/woff2"
    ".ttf"   = "font/ttf"
    ".otf"   = "font/otf"
    ".eot"   = "application/vnd.ms-fontobject"
    ".wasm"  = "application/wasm"
    ".zip"   = "application/zip"
    ".gz"    = "application/gzip"
  }

}

// Public CDN to serve frontend - main domain
module "cdn_idpay_bonuselettrodomestici" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor"
  # source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//cdn_frontdoor?ref=PAYMCLOUD-477-v-4-creazione-modulo-cdn-front-door-per-sostituire-cdn-classic-deprecata"

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

  delivery_rule_redirects = local.bonus_redirect

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

## Upload static content for Bonus Elettrodomesici - products
resource "azurerm_storage_blob" "eie_static_files" {
  for_each = toset(local.upload_eie_files)

  name                   = "elenco-informatico-elettrodomestici/${each.value}"
  storage_account_name   = module.cdn_idpay_bonuselettrodomestici.storage_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/cdn/bonus-el-products/${each.value}"
  content_type = lookup(
    local.content_type_map,
    try(lower(regex("\\.[^.]+$", each.value)), ""),
    "application/octet-stream"
  )
}

## Upload static content for Bonus Elettrodomesici - point of sales
resource "azurerm_storage_blob" "pos_static_files" {
  for_each = toset(local.upload_pos_files)

  name                   = "lista-punti-vendita/${each.value}"
  storage_account_name   = module.cdn_idpay_bonuselettrodomestici.storage_name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "${path.module}/cdn/bonus-el-pos/${each.value}"
  content_type = lookup(
    local.content_type_map,
    try(lower(regex("\\.[^.]+$", each.value)), ""),
    "application/octet-stream"
  )
}
