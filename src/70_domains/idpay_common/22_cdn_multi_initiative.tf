module "cdn_multi_initiative" {
  source = "./.terraform/modules/__v4__/cdn_frontdoor_multiple"

  resource_group_name        = local.data_rg
  location                   = var.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
  tenant_id                  = data.azurerm_client_config.current.tenant_id

  # CDN Profile
  profile = {
    name = "${local.project}-multi-initiative"
  }

  storage_account = {
    enabled                  = true
    account_name             = "${local.project}multinit"
    account_replication_type = contains(["d", "u"], var.env_short) ? "LRS" : "ZRS"
    index_document           = "index.html"
    error_404_document       = "error.html"
    origin_group             = "web-group"
  }

  custom_domains = {
    (local.public_dns_zone_pari) = {
      dns_zone_name                = local.public_dns_zone_pari
      dns_zone_resource_group_name = local.core_network_rg
      certificate_type             = "CustomerCertificate"
      keyvault_id                  = data.azurerm_key_vault.domain_kv.id
      keyvault_certificate_name    = replace(local.public_dns_zone_pari, ".", "-")
      enable_dns_records           = true
    }
  }

  endpoints = {
    "web" = {
      name = "${local.project}-cdn-web"
    }
  }

  origin_groups = {
    "web-group" = {
      description = "Static content pool for multi-initiative CDN"
      members     = [] # The storage account origin is wired automatically when the storage account is enabled and the origin group is specified.

      health_probe = {
        path                = "/"
        protocol            = "Https"
        request_type        = "GET"
        interval_in_seconds = 120
      }

      load_balancing = {
        sample_size                        = 4
        successful_samples_required        = 2
        additional_latency_in_milliseconds = 0
      }
    }
  }

  routes = {
    "web" = {
      endpoint       = "web"
      origin_group   = "web-group"
      patterns       = ["/*"]
      protocols      = ["Http", "Https"]
      forwarding     = "MatchRequest"
      https_redirect = true
      cache_behavior = "IgnoreQueryString"
      custom_domains = [local.public_dns_zone_pari]
      rulesets       = ["WebGlobal"]
      enabled        = true
    }
  }
  rulesets = {
    "WebGlobal" = {
      description = "Global ruleset for multi-initiative CDN"
      rules = {
        "RewriteInitiativeSpaRouting" = {
          order             = 10
          behavior_on_match = "Stop"

          conditions = [
            {
              type             = "url_path"
              operator         = "RegEx"
              match_values     = ["^/(${local.bonus_initiatives_regex}])/(${local.bonus_spa_regex})/assets/"]
              negate_condition = true
            },
            {
              type             = "url_path"
              operator         = "RegEx"
              match_values     = ["^/(${local.bonus_initiatives_regex})/(${local.bonus_spa_regex})/"]
              negate_condition = false
            },
            {
              type             = "url_file_extension"
              operator         = "LessThanOrEqual"
              match_values     = ["0"]
              negate_condition = false
              transforms       = []
            }
          ]

          actions = [{
            type                    = "rewrite"
            source_pattern          = "/"
            destination             = "/{url_path:seg0}/{url_path:seg1}/index.html"
            preserve_unmatched_path = false
          }]
        }
      }
    }
  }
}
