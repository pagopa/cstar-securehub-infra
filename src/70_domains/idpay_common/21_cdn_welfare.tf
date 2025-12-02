locals {
  spa_rewrite_urls = [
    for i, spa in var.single_page_applications_roots_dirs :
    {
      name  = replace(replace("rewrite-SPA-${spa}", "-", ""), "/", "0")
      order = i + 3 // +3 required because the order start from 1: 1 is reserved for default application redirect; 2 is reserved for the https rewrite;

      url_path_conditions = [{
        operator         = "BeginsWith"
        match_values     = ["/${spa}/"]
        negate_condition = false
        transforms       = null
      }]

      url_file_extension_conditions = [{
        operator         = "LessThanOrEqual"
        match_values     = ["0"]
        negate_condition = false
        transforms       = null
      }]

      url_rewrite_actions = [{
        source_pattern          = "/${spa}/"
        destination             = "/${spa}/index.html"
        preserve_unmatched_path = false
      }]
    }
  ]
}

/**
 * CDN
 */
// public_cstar storage used to serve FE
module "cdn_idpay_welfare" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor"

  cdn_prefix_name     = "${local.project}-welfare"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location

  custom_domains = [
    {
      domain_name             = "welfare.${data.azurerm_dns_zone.public_cstar.name}"
      dns_name                = data.azurerm_dns_zone.public_cstar.name
      dns_resource_group_name = data.azurerm_dns_zone.public_cstar.resource_group_name
      ttl                     = var.env != "p" ? 300 : 3600
    }
  ]

  storage_account_name               = "${local.project}welcdnsa"
  storage_account_replication_type   = var.idpay_cdn_storage_account_replication_type
  storage_account_index_document     = "index.html"
  storage_account_error_404_document = "error.html"

  querystring_caching_behaviour = "IgnoreQueryString"

  global_delivery_rules = [{
    order = 1
    # HSTS
    modify_response_header_actions = [
      # Content-Security-Policy (in Report mode)
      {
        action = "Overwrite"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "default-src 'self'; object-src 'none'; connect-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ https://api-eu.mixpanel.com/track/ https://cdn.cookielaw.org https://privacyportal-de.onetrust.com https://${module.storage_idpay_refund.name}.blob.core.windows.net; script-src 'self' https://cdn.cookielaw.org https://privacyportal-de.onetrust.com https://privacyportalde-cdn.onetrust.com;"
      },
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "style-src 'self' 'unsafe-inline' https://${local.selfare_subdomain}.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://${local.selfare_subdomain}.pagopa.it/assets/font/; "
      },
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_welfare.storage_primary_web_host} https://${var.env != "prod" ? "${var.env}." : ""}${local.selfare_subdomain}.pagopa.it https://selc${var.env_short}checkoutsa.z6.web.core.windows.net/ https://cdn.cookielaw.org/ data:; "
      },
    ]
    },
    {
      order = 2
      # HSTS
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

  delivery_rule_rewrites = concat(
    [
      {
        name  = "RewriteDefaultApplication"
        order = 10
        // conditions
        url_path_conditions = [{
          operator         = "Equal"
          match_values     = ["/"]
          negate_condition = false
          transforms       = null
        }]
        url_rewrite_actions = [{
          source_pattern          = "/"
          destination             = "/portale-enti/index.html"
          preserve_unmatched_path = false
        }]
      }
    ],
    [
      {
        name  = "RewriteOIDCConfiguration"
        order = 20
        // conditions
        url_path_conditions = [{
          operator         = "Equal"
          match_values     = ["/selfcare/openid-configuration.json"]
          negate_condition = false
          transforms       = null
        }]
        url_rewrite_actions = [{
          source_pattern          = "/selfcare"
          destination             = "/selfcare/openid-configuration.json"
          preserve_unmatched_path = false
        }]
      }
    ],
    local.spa_rewrite_urls
  )

  delivery_custom_rules = [
    {
      name  = "robotsNoIndex"
      order = 20 + length(local.spa_rewrite_urls)

      // conditions
      url_path_conditions = [{
        operator         = "Equal"
        match_values     = length(var.robots_indexed_paths) > 0 ? var.robots_indexed_paths : ["dummy"]
        negate_condition = true
        transforms       = null
      }]

      // actions
      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "X-Robots-Tag"
        value  = "noindex, nofollow"
      }]
    },
    {
      name  = "microcomponentsNoCache"
      order = 30 + length(local.spa_rewrite_urls)

      // conditions
      url_file_name_conditions = [{
        operator         = "Equal"
        match_values     = ["remoteEntry.js"]
        negate_condition = false
        transforms       = null
      }]

      // actions
      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "Cache-Control"
        value  = "no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0"
      }]
    }
  ]

  tags                       = module.tag_config.tags
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core_log_analytics.id
}

#
# 🔑 Cannot be merged in local values, because contains sensitive data
#
resource "azurerm_key_vault_secret" "idpay_welfare_cdn_storage_primary_access_key" {
  name         = "web-storage-access-key"
  value        = module.cdn_idpay_welfare.storage_primary_access_key
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "idpay_welfare_cdn_storage_primary_connection_string" {
  name         = "web-storage-connection-string"
  value        = module.cdn_idpay_welfare.storage_primary_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_key_vault_secret" "idpay_welfare_cdn_storage_blob_connection_string" {
  name         = "web-storage-blob-connection-string"
  value        = module.cdn_idpay_welfare.storage_primary_blob_connection_string
  content_type = "text/plain"

  key_vault_id = data.azurerm_key_vault.domain_kv.id
}

resource "azurerm_storage_blob" "selfcare_oidc_configuration" {
  name                   = "selfcare/openid-configuration.json"
  storage_account_name   = module.cdn_idpay_welfare.storage_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/json"
  access_tier            = "Hot"

  source_content = templatefile("./cdn/openid-configuration.json.tpl", {
    selfcare-issuer = local.selfcare_issuer
  })
}
