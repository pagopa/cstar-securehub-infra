locals {
  cbi_token_url = var.env_short == "p" ? "https://cbiglobeopenbankingapigateway.nexi.it/nexi/oauth/v2/token" : "https://stgcbiglobeopenbankingapigateway.nexi.it/nexi/oauth/v2/token"
  ms_token_url  = var.env_short == "p" ? "https://login.microsoftonline.com/761de76f-3d5c-4174-917c-5ad4d06360cb/oauth2/v2.0/token" : "https://login.microsoftonline.com/08b638e8-0676-45cc-b677-5c038b17d28a/oauth2/v2.0/token"

  workbook_tabs = [
    {
      name     = "Tabs"
      filePath = "${path.module}/workbooks/tabs/tabs.json.tpl"
    },
    {
      name     = "Finestra Osservabilità"
      filePath = "${path.module}/workbooks/tabs/finestra-osservabilità.json.tpl"
    },
    {
      name     = "Servizi per i SP"
      filePath = "${path.module}/workbooks/tabs/servizi-per-sp.json.tpl"
    },
    {
      name     = "Activator"
      filePath = "${path.module}/workbooks/tabs/activator.json.tpl"
    },
    {
      name     = "Invii SRTP"
      filePath = "${path.module}/workbooks/tabs/invii-srtp.json.tpl"
    },
    {
      name     = "Accessi Account Storage"
      filePath = "${path.module}/workbooks/tabs/accessi-account-storage.json.tpl"
    },
    {
      name     = "Autenticazione"
      filePath = "${path.module}/workbooks/tabs/autenticazione.json.tpl"
    },
    {
      name     = "Monitoraggio Service Providers"
      filePath = "${path.module}/workbooks/tabs/monitoraggio-service-providers.json.tpl"
    },
    {
      name     = "JKS"
      filePath = "${path.module}/workbooks/tabs/jks.json.tpl"
    },
    {
      name     = "Invii RTP (API)"
      filePath = "${path.module}/workbooks/tabs/inviiAPI.json.tpl"
    },
    {
      name     = "Cancellazioni RTP (API)"
      filePath = "${path.module}/workbooks/tabs/cancellazioneAPI.json.tpl"
    },
    {
      name     = "Servizi per gli Enti"
      filePath = "${path.module}/workbooks/tabs/servizienti.json.tpl"
    },
    {
      name     = "Accessi Get Enti"
      filePath = "${path.module}/workbooks/tabs/getPayees.json.tpl"
    },
  ]

  workbook_items = join(",", [
    for tab in local.workbook_tabs :
    templatefile(tab.filePath, {
      subscription_id = data.azurerm_subscription.current.subscription_id
      prefix          = var.prefix
      domain          = var.domain
      env_short       = var.env_short
      location_short  = var.location_short
      cbi_token_url   = local.cbi_token_url
      ms_token_url    = local.ms_token_url
    })
  ])
}


resource "azurerm_application_insights_workbook" "srtp_workbook" {
  name                = uuidv5("oid", "srtp-workbook")
  resource_group_name = data.azurerm_resource_group.srtp_monitoring_rg.name
  location            = data.azurerm_resource_group.srtp_monitoring_rg.location
  display_name        = "SRTP OER"

  data_json = templatefile("${path.module}/workbooks/SRTPWorkbook.json.tpl", {
    items = local.workbook_items
  })

  tags = module.tag_config.tags
}
