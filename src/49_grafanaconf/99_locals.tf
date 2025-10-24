locals {
  project          = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product          = "${var.prefix}-${var.env_short}"
  product_nodomain = "${var.prefix}-${var.env_short}-${var.location_short}"

  #
  # Monitoring
  #
  law_name           = "${local.project}-monitoring-law"
  monitoring_rg_name = "cstar-${var.env_short}-itn-platform-monitoring-rg"

  law_name_core_itn    = "${local.product_nodomain}-core-law"
  law_name_core_itn_rg = "${local.product_nodomain}-core-monitor-rg"
  law_name_core        = "${local.product}-law"
  law_name_core_rg     = "${local.product}-monitor-rg"

  law_name_srtp    = "${local.product_nodomain}-srtp-law"
  law_name_srtp_rg = "${local.product_nodomain}-srtp-monitoring-rg"

  law_name_mcshared    = "${local.product_nodomain}-mcshared-law"
  law_name_mcshared_rg = "${local.product_nodomain}-mcshared-monitoring-rg"

  grafana_name = "cstar-${var.env_short}-itn-grafana"

  #
  # KV
  #
  kv_cicd_name                = "${local.product_nodomain}-cicd-kv"
  kv_cicd_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  kv_core_name                = "${local.product_nodomain}-core-kv"
  kv_core_resource_group_name = "${local.product_nodomain}-core-sec-rg"

  # Configuration for different team products and their AKS clusters
  # Contains settings for each team's environment including:
  # - location_short: Geographic location code
  # - monitor_workspace_id: Log Analytics workspace ID for monitoring
  # - aks_name: Name of the AKS cluster
  team_product = {
    idpay = {
      groups = lookup(var.team_groups, "idpay", {})
      aks = {
        location_short       = "itn",
        monitor_workspace_id = data.azurerm_log_analytics_workspace.law_core_itn.id,
        aks_name             = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}-aks"
      },
    }
    mil = {
      groups = lookup(var.team_groups, "mil", {})
      aks = {
        location_short       = "weu",
        monitor_workspace_id = data.azurerm_log_analytics_workspace.law_core.id,
        aks_name             = "${var.prefix}-${var.env_short}-weu-${var.env}01-aks"
      }
    },
    rtd = {
      groups = lookup(var.team_groups, "rtd", {})
      aks = {
        location_short       = "weu",
        monitor_workspace_id = data.azurerm_log_analytics_workspace.law_core.id,
        aks_name             = "${var.prefix}-${var.env_short}-weu-${var.env}01-aks"
      }
    },
    srtp = {
      groups = lookup(var.team_groups, "srtp", {})
      aca = {
        location_short       = "itn",
        monitor_workspace_id = data.azurerm_log_analytics_workspace.law_srtp.id,
      }
    },
    mcshared = {
      groups = lookup(var.team_groups, "mcshared", {})
      aca = {
        location_short       = "itn",
        monitor_workspace_id = data.azurerm_log_analytics_workspace.law_mcshared.id,
      }
    }
  }
}
