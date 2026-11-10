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

  # 🔔 Alerts
  alert_secret_names = contains(["p", "u"], var.env_short) ? ["jsm-azure-api-key", "email-mdc-slack"] : []

  jsm_webhook_uri = one([
    for k, v in module.secrets.values :
    "https://api.atlassian.com/jsm/ops/integration/v1/json/azure?apiKey=${v.value}"
    if k == "jsm-azure-api-key"
  ])

  alert_email_slack_addresses = [
    for k, v in module.secrets.values : v.value if k == "email-mdc-slack"
  ]

  # Base configuration shared across all alerts.
  # Modify here to change global behavior.
  base_alert_config = {
    evaluation_frequency = "PT10M"
    window_duration      = "PT10M"
    severity             = 1
    threshold            = 0
    enabled              = true
    operator             = "GreaterThan"
  }

  # MDC domain alerts map.
  # To add a new alert: add an entry here + the corresponding .kql file
  alerts_mdc = {
    retry_failures = {
      name        = "${var.domain}-send-psp-retry-exhausted-${var.env}"
      description = "Send of message to PSP failed after 3 retry."
      query       = file("${path.module}/queries-KQL/retry_failures.kql")
    }
    api_5xx_errors = {
      name        = "${var.domain}-send-message-errors-5xx-${var.env}"
      description = "Error 5XX on sendMessage API"
      query       = file("${path.module}/queries-KQL/api_5xx_errors.kql")
    }
  }

  # Alert active only on UAT (subset of alerts_mdc)
  alerts_uat = {
    api_5xx_errors = merge(
      local.alerts_mdc.api_5xx_errors,
      { severity = 2 }
    )
  }

  # Merge base config + alert-specific data.
  final_alerts = {
    for key, alert in(
      var.env_short == "p" ? local.alerts_mdc :
      var.env_short == "u" ? local.alerts_uat :
      {}
    ) :
    key => merge(local.base_alert_config, alert)
  }

  # ----------------------------------------------------------------------------
  # GITHUB RUNNERS
  # ----------------------------------------------------------------------------

  #
  # List of GitHub repositories which need self-hosted runners.
  #
  github_repositories_with_self_hosted_runners = [
    {
      name : "emd-testing",
      short_name : "emd-testing"
    },
    {
      name : "emd-message-core",
      short_name : "message-core"
    },
    {
      name : "emd-notifier-sender",
      short_name : "notifier-sender"
    },
    {
      name : "emd-tpp",
      short_name : "tpp"
    }
  ]

  #
  # Data of Container Apps Environment for GitHub Runners.
  #
  gh_runners_cae_name = "${var.prefix}-${var.env_short}-${var.location_short}-platform-github-cae"
  gh_runners_cae_rg   = "${var.prefix}-${var.env_short}-${var.location_short}-platform-compute-rg"

  #
  # Name of the secret that contains the GitHub token.
  #
  gh_token_secret = "emd-bot-github-rw-TOKEN"
}
