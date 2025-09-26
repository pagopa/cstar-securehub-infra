resource "azurerm_application_insights_workbook" "srtp_workbook" {
  name                = uuidv5("oid", "srtp-workbook")
  resource_group_name = data.azurerm_resource_group.srtp_monitoring_rg.name
  location            = data.azurerm_resource_group.srtp_monitoring_rg.location
  display_name        = "SRTP Workbook"

  data_json = templatefile("${path.module}/workbooks/SRTPWorkbook.json.tpl", {
    subscription_id = data.azurerm_subscription.current.subscription_id
    prefix          = var.prefix
    domain          = var.domain
    env_short       = var.env_short
    location_short  = var.location_short
  })

  tags = var.tags
}