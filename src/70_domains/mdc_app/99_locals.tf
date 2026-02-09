locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  tags = module.tag_config.tags

  # 📊 Monitoring
  monitor_appinsights_name     = "${local.product}-appinsights"
  monitor_resource_group_name  = "${local.product}-monitor-rg"
  log_analytics_workspace_name = "${local.product}-law"
  monitor_action_group_slack   = "SlackPagoPA"
  monitor_action_group_email   = "PagoPA"

  #
  # AKS
  #
  aks_name                = "${local.product}-${var.location_short}-${var.env}-aks"
  aks_resource_group_name = "${local.product}-${var.location_short}-core-aks-rg"

  # 🔎 DNS / Ingress
  ingress_hostname_prefix = "${var.domain}.${var.location_short}"
  domain_aks_hostname     = var.env == "prod" ? "${local.ingress_hostname_prefix}.internal.cstar.pagopa.it" : "${local.ingress_hostname_prefix}.internal.${var.env}.cstar.pagopa.it"

  # 🔗 API Management
  apim_name    = "${local.product}-apim"
  apim_rg_name = "${local.product}-api-rg"

  # 🔒 Key Vault
  kv_domain_name    = "${local.project}-kv"
  kv_domain_rg_name = "${local.project}-security-rg"

  # 📥 Event Hub (data sources)
  eventhub_namespace_name    = "${local.project}-evh"
  eventhub_namespace_rg_name = "${local.project}-data-rg"

  aks_api_url = var.env_short == "d" ? data.azurerm_kubernetes_cluster.aks.fqdn : data.azurerm_kubernetes_cluster.aks.private_fqdn

  ### ARGOCD
  argocd_internal_url = "argocd.${var.location_short}.${var.dns_zone_internal_prefix}.${var.external_domain}"

  secret_name_workload_identity_client_id            = "mdc-itn-workload-identity-client-id"
  secret_name_workload_identity_service_account_name = "mdc-itn-workload-identity-service-account-name"
}
