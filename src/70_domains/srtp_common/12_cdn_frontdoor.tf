module "cdn_frontdoor" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor"
  count  = var.enable_cdn ? 1 : 0

  cdn_prefix_name     = "${local.project}-fe"
  resource_group_name = local.data_rg_name
  location            = var.location

  custom_domains = [
    {
      domain_name             = "rtp.${local.dns_zone_name}"
      dns_name                = local.dns_zone_name
      dns_resource_group_name = local.vnet_legacy_core_rg
      ttl                     = var.env != "p" ? 300 : 3600
    }
  ]
  storage_account_error_404_document = "error_404.html"
  storage_account_index_document     = "index.html"

  global_delivery_rules = [{
    order = 1

    # HSTS
    modify_response_header_actions = [
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
  }]


  delivery_rule_rewrites = [{
    name  = "RewriteRulesForReactRouting"
    order = 2

    url_file_extension_conditions = [{
      operator         = "LessThan"
      match_values     = ["1"]
      transforms       = []
      negate_condition = false
    }]

    url_rewrite_actions = [{
      source_pattern          = "/"
      destination             = "/index.html"
      preserve_unmatched_path = false
    }]
  }]

  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id

  tags = module.tag_config.tags
}
