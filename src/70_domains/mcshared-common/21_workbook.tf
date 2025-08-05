
resource "azurerm_application_insights_workbook" "workbook" {
  count = contains(["p"], var.env_short) ? 1 : 0

  name                = uuidv5("oid", var.prefix)
  resource_group_name = local.monitor_rg_name
  location            = var.location
  display_name        = "MIL AUTH ${upper(var.env)} v2"
  data_json = templatefile("${path.module}/workbook/mil_auth_workbook.json",
    {
      subscription_id = data.azurerm_subscription.current.subscription_id
      prefix          = var.prefix
      env_short       = var.env_short
  })

  tags = var.tags
}
