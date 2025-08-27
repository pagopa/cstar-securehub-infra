locals {
  selfare_asset_temp_suffix = "-italy"
  spa_asset_rewrite = [
    for i, spa_asset in var.single_page_applications_asset_register_roots_dirs :
    {
      name  = replace(replace("rewrite-SPA-${spa_asset}", "-", ""), "/", "0")
      order = i + 3 // +3 required because the order start from 1: 1 is reserved for default application redirect; 2 is reserved for the https rewrite;

      url_path_conditions = [{
        operator         = "BeginsWith"
        match_values     = ["/${spa_asset}/"]
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
        source_pattern          = "/${spa_asset}/"
        destination             = "/${spa_asset}/index.html"
        preserve_unmatched_path = false
      }]

      url_rewrite_action = {
        source_pattern          = "/${spa_asset}/"
        destination             = "/${spa_asset}/index.html"
        preserve_unmatched_path = false
      }
    }
  ]
}

/**
 * CDN
 */
// public_cstar storage used to serve FE
module "cdn_idpay_assetregister" {
  # source = "./.terraform/modules/__v4__/cdn"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//cdn_frontdoor?ref=PAYMCLOUD-477-v-4-creazione-modulo-cdn-front-door-per-sostituire-cdn-classic-deprecata"

  cdn_prefix_name     = "${local.project}-asset-register"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location

  custom_domains = [
    {
      domain_name             = "registrodeibeni.${data.azurerm_dns_zone.public_cstar.name}"
      dns_name                = data.azurerm_dns_zone.public_cstar.name
      dns_resource_group_name = data.azurerm_dns_zone.public_cstar.resource_group_name
      ttl                     = var.env != "p" ? 300 : 3600
    }
  ]

  storage_account_name               = "${local.project}regcdnsa"
  storage_account_replication_type   = var.idpay_cdn_storage_account_replication_type
  storage_account_index_document     = "index.html"
  storage_account_error_404_document = "error.html"

  querystring_caching_behaviour = "IgnoreQueryString"
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.core_log_analytics.id

  global_delivery_rules = [{
    order = 1
    # HSTS
    modify_response_header_action = [
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "default-src 'self'; object-src 'none'; connect-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ https://api-eu.mixpanel.com/track/; "
      },
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "script-src 'self'; style-src 'self' 'unsafe-inline' https://${local.selfare_subdomain}.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://selfcare${local.selfare_asset_temp_suffix}.pagopa.it/assets/font/; "
      },
      # {
      #   action = "Append"
      #   name   = "Content-Security-Policy-Report-Only"
      #   value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_assetregister.storage_primary_web_host} https://${var.env != "prod" ? "${var.env}." : ""}{local.selfare_subdomain}.pagopa.it https://selc${var.env_short}checkoutsa.z6.web.core.windows.net/institutions/ data:; "
      # },

    ]
    },
    {
      order = 2
      # HSTS
      modify_response_header_action = [{
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
    }
  ]

  delivery_rule_rewrite = concat([{
      name  = "RewritesDefaultApplication"
      order = 20

      url_path_conditions = [{
        operator         = "Equal"
        match_values     = ["/"]
        negate_condition = false
        transforms       = null
      }]
      url_rewrite_actions = [{
        source_pattern          = "/"
        destination             = "/registro-dei-beni/index.html"
        preserve_unmatched_path = false
      }]
    }],
    local.spa_asset_rewrite
  )

  delivery_custom_rules = [
    {
      name  = "robotsNoIndex"
      order = 30 + length(local.spa_asset_rewrite)

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
      order = 40 + length(local.spa_asset_rewrite)

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

  tags = module.tag_config.tags
}
