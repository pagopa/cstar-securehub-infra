locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  tags = module.tag_config.tags

  # Default Domain Resource Group
  data_rg     = "${local.project}-data-rg"
  security_rg = "${local.project}-security-rg"
  compute_rg  = "${local.project}-compute-rg"
  cicd_rg     = "${local.project}-cicd-rg"
  monitor_rg  = "${local.project}-monitoring-rg"

  # 📊 Monitoring
  monitor_appinsights_name     = "${local.project}-appinsights"
  log_analytics_workspace_name = "${local.project}-law"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  # 🔗 API Management
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"

  # 🔒 Key Vault
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-security-rg"

  # 📥 Event Hub (data sources)
  eventhub_namespace_name    = "${local.project}-evh"
  eventhub_namespace_rg_name = "${local.project}-data-rg"

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"
}
