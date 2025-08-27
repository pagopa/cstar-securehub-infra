module "cdn_idpay_selfcare" {
  # source = "./.terraform/modules/__v4__/cdn"
  source = "git::https://github.com/pagopa/terraform-azurerm-v4.git//cdn_frontdoor?ref=PAYMCLOUD-477-v-4-creazione-modulo-cdn-front-door-per-sostituire-cdn-classic-deprecata"

  cdn_prefix_name     = "${local.project}-selfcare"
  resource_group_name = data.azurerm_resource_group.idpay_data_rg.name
  location            = var.location

  custom_domains = [
    {
      domain_name             = "selfcare-italy.${data.azurerm_dns_zone.public_cstar.name}"
      dns_name                = data.azurerm_dns_zone.public_cstar.name
      dns_resource_group_name = data.azurerm_dns_zone.public_cstar.resource_group_name
      ttl                     = var.env != "p" ? 300 : 3600
    }
  ]

  storage_account_name               = "${local.project}selcdnsa"
  storage_account_replication_type   = var.selfcare_welfare_cdn_storage_account_replication_type
  storage_account_index_document     = "index.html"
  storage_account_error_404_document = "not_found.html"

  querystring_caching_behaviour = "IgnoreQueryString"
  log_analytics_workspace_id    = data.azurerm_log_analytics_workspace.core_log_analytics.id

  global_delivery_rules = [{
    order = 1

    # HSTS
    modify_response_header_actions = [{
      action = "Overwrite"
      name   = "Strict-Transport-Security"
      value  = "max-age=31536000"
      },
    ]
  }]

  // https://antbutcher.medium.com/hosting-a-react-js-app-on-azure-blob-storage-azure-cdn-for-ssl-and-routing-8fdf4a48feeb
  // it is important to add base tag in index.html too (i.e. <base href="/">)
  delivery_rule_rewrites = [{
    name  = "RewriteRules"
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

  tags = module.tag_config.tags
}

locals {
  selfcare-issuer = var.env == "prod" ?  "https://selfcare.pagopa.it" : "https://${var.env}.selfcare.pagopa.it"
}

resource "azurerm_storage_blob" "oidc_configuration" {
  name                   = "selfcare/openid-configuration.json"
  storage_account_name   = module.cdn_idpay_selfcare.storage_name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "application/json"
  access_tier            = "Hot"

  source_content = templatefile("./cdn/openid-configuration.json.tpl", {
    selfcare-issuer = local.selfcare-issuer
  })

  depends_on = [
    module.cdn_idpay_selfcare
  ]
}
