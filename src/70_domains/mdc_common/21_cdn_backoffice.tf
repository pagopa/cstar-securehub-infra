/**
 * CDN FrontDoor per emd-ar-backoffice-fe (SPA statica)
 * Dominio: mdc.{dev.|uat.|}cstar.pagopa.it
 */
module "cdn_mdc_backoffice" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor"

  cdn_prefix_name     = "${local.project}-backoffice"
  resource_group_name = data.azurerm_resource_group.mdc_data_rg.name
  location            = var.location

  custom_domains = [
    {
      domain_name             = "mdc.${data.azurerm_dns_zone.public_mdc.name}"
      dns_name                = data.azurerm_dns_zone.public_mdc.name
      dns_resource_group_name = data.azurerm_dns_zone.public_mdc.resource_group_name
      ttl                     = var.env_short != "p" ? 300 : 3600
    }
  ]

  storage_account_name               = replace("${local.project}backoffice", "-", "")
  storage_account_replication_type   = var.backoffice_cdn_storage_replication_type
  storage_account_index_document     = "index.html"
  storage_account_error_404_document = "index.html"

  querystring_caching_behaviour = "IgnoreQueryString"
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.log_analytics_workspace.id

  global_delivery_rules = [
    {
      order = 1
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
    }
  ]

  delivery_rule_rewrites = [
    {
      name  = "RewriteDefaultToIndex"
      order = 1

      url_path_conditions = [{
        operator         = "Equal"
        match_values     = ["/"]
        negate_condition = false
        transforms       = null
      }]
      url_rewrite_actions = [{
        source_pattern          = "/"
        destination             = "/index.html"
        preserve_unmatched_path = false
      }]
    },
    {
      # SPA fallback: path senza estensione → index.html (React Router)
      name  = "RewriteSPAFallback"
      order = 2

      url_path_conditions = [{
        operator         = "BeginsWith"
        match_values     = ["/"]
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
        source_pattern          = "/"
        destination             = "/index.html"
        preserve_unmatched_path = false
      }]
    }
  ]

  delivery_custom_rules = [
    {
      name  = "robotsNoIndex"
      order = 10

      url_path_conditions = [{
        operator         = "Equal"
        match_values     = length(var.robots_indexed_paths) > 0 ? var.robots_indexed_paths : ["dummy"]
        negate_condition = true
        transforms       = null
      }]

      modify_response_header_actions = [{
        action = "Overwrite"
        name   = "X-Robots-Tag"
        value  = "noindex, nofollow"
      }]
    }
  ]

  tags = module.tag_config.tags
}
