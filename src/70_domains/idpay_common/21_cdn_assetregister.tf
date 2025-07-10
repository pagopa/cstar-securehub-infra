locals {
  selfare_asset_temp_suffix = "-italy"
  spa_asset = [
    for i, spa_asset in var.single_page_applications_asset_register_roots_dirs :
    {
      name  = replace(replace("SPA-${spa_asset}", "-", ""), "/", "0")
      order = i + 3 // +3 required because the order start from 1: 1 is reserved for default application redirect; 2 is reserved for the https rewrite;
      conditions = [
        {
          condition_type   = "url_path_condition"
          operator         = "BeginsWith"
          match_values     = ["/${spa_asset}/"]
          negate_condition = false
          transforms       = null
        },
        {
          condition_type   = "url_file_extension_condition"
          operator         = "LessThanOrEqual"
          match_values     = ["0"]
          negate_condition = false
          transforms       = null
        },
      ]
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
  source = "./.terraform/modules/__v4__/cdn"

  name                = "asset-register"
  prefix              = local.project_weu
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location
  cdn_location        = var.location_weu

  hostname              = "registrodeibeni.${data.azurerm_dns_zone.public_cstar.name}"
  https_rewrite_enabled = true

  storage_account_name             = "${local.project}regcdnsa"
  storage_account_replication_type = var.idpay_cdn_storage_account_replication_type
  index_document                   = "index.html"
  error_404_document               = "error.html"

  dns_zone_name                = data.azurerm_dns_zone.public_cstar.name
  dns_zone_resource_group_name = data.azurerm_dns_zone.public_cstar.resource_group_name

  keyvault_resource_group_name = local.idpay_kv_rg_name
  keyvault_subscription_id     = data.azurerm_subscription.current.subscription_id
  keyvault_vault_name          = local.idpay_kv_name

  querystring_caching_behaviour = "BypassCaching"
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.core_log_analytics.id

  advanced_threat_protection_enabled = var.idpay_cdn_sa_advanced_threat_protection_enabled

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
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "default-src 'self'; object-src 'none'; connect-src 'self' https://api-io.${var.dns_zone_prefix}.${var.external_domain}/ https://api-eu.mixpanel.com/track/; "
      },
      {
        action = "Append"
        name   = contains(["d"], var.env_short) ? "Content-Security-Policy-Report-Only" : "Content-Security-Policy"
        value  = "script-src 'self'; style-src 'self' 'unsafe-inline' https://selfcare${local.selfare_asset_temp_suffix}.pagopa.it/assets/font/selfhostedfonts.css; worker-src 'none'; font-src 'self' https://selfcare${local.selfare_asset_temp_suffix}.pagopa.it/assets/font/; "
      },
      # {
      #   action = "Append"
      #   name   = "Content-Security-Policy-Report-Only"
      #   value  = "img-src 'self' https://assets.cdn.io.italia.it https://${module.cdn_idpay_assetregister.storage_primary_web_host} https://${var.env != "prod" ? "${var.env}." : ""}selfcare${local.selfare_asset_temp_suffix}.pagopa.it https://selc${var.env_short}checkoutsa.z6.web.core.windows.net/institutions/ data:; "
      # },
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

  delivery_rule_rewrite = concat([{
    name  = "defaultApplication"
    order = 2
    conditions = [
      {
        condition_type   = "url_path_condition"
        operator         = "Equal"
        match_values     = ["/"]
        negate_condition = false
        transforms       = null
      }
    ]
    url_rewrite_action = {
      source_pattern          = "/"
      destination             = "/registro-dei-beni/index.html"
      preserve_unmatched_path = false
    }
    }],
    local.spa_asset
  )

  delivery_rule = [
    {
      name  = "robotsNoIndex"
      order = 3 + length(local.spa_asset)

      // conditions
      url_path_conditions = [{
        operator         = "Equal"
        match_values     = length(var.robots_indexed_paths) > 0 ? var.robots_indexed_paths : ["dummy"]
        negate_condition = true
        transforms       = null
      }]
      cookies_conditions            = []
      device_conditions             = []
      http_version_conditions       = []
      post_arg_conditions           = []
      query_string_conditions       = []
      remote_address_conditions     = []
      request_body_conditions       = []
      request_header_conditions     = []
      request_method_conditions     = []
      request_scheme_conditions     = []
      request_uri_conditions        = []
      url_file_extension_conditions = []
      url_file_name_conditions      = []

      // actions
      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "X-Robots-Tag"
        value  = "noindex, nofollow"
      }]
      cache_expiration_actions       = []
      cache_key_query_string_actions = []
      modify_request_header_actions  = []
      url_redirect_actions           = []
      url_rewrite_actions            = []
    },
    {
      name  = "microcomponentsNoCache"
      order = 4 + length(local.spa_asset)

      // conditions
      url_path_conditions           = []
      cookies_conditions            = []
      device_conditions             = []
      http_version_conditions       = []
      post_arg_conditions           = []
      query_string_conditions       = []
      remote_address_conditions     = []
      request_body_conditions       = []
      request_header_conditions     = []
      request_method_conditions     = []
      request_scheme_conditions     = []
      request_uri_conditions        = []
      url_file_extension_conditions = []

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
      cache_expiration_actions       = []
      cache_key_query_string_actions = []
      modify_request_header_actions  = []
      url_redirect_actions           = []
      url_rewrite_actions            = []
    }
  ]

  tags = module.tag_config.tags
}
