# #
# # Data Collection Rule
# #
# locals {
#   # log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
#   # log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
#   audit_dce_name               = "${var.domain}${var.env_short}-audit-dce"
#   audit_dcr_name               = "${var.domain}${var.env_short}-audit-dcr"
#   audit_dcra_name              = "${var.domain}${var.env_short}-audit-dcra"
#   subscription_id              = data.azurerm_subscription.current.subscription_id
#   resource_group_name          = data.azurerm_application_insights.application_insights.resource_group_name
#   audit_dce_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionEndpoints/${local.audit_dce_name}"
#   audit_dcr_id                 = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}"
#   az_rest_api_dcr              = "https://management.azure.com/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/dataCollectionRules/${local.audit_dcr_name}?api-version=2021-09-01-preview"
# }
#
# resource "azurerm_monitor_data_collection_endpoint" "idpay_audit_dce" {
#   name                          = local.audit_dce_name
#   resource_group_name           = data.azurerm_application_insights.application_insights.resource_group_name
#   location                      = var.location
#   public_network_access_enabled = true
#   description                   = "audit dce"
# }
#
# # Data Collection Rule
# resource "azapi_resource" "idpay_audit_dcr" {
#   type      = "Microsoft.Insights/dataCollectionRules@2021-09-01-preview"
#   name      = local.audit_dcr_name
#   parent_id = data.azurerm_resource_group.monitor_rg.id
#
#   body = templatefile("./dcr/idpay-audit-dcr.json.tpl", {
#     log_analytics_workspace_id   = data.azurerm_log_analytics_workspace.log_analytics.id
#     log_analytics_workspace_name = data.azurerm_log_analytics_workspace.log_analytics.name
#     audit_dce_id                 = local.audit_dce_id
#     audit_dcr_name               = local.audit_dcr_name
#   })
#
#   depends_on = [azurerm_monitor_data_collection_endpoint.idpay_audit_dce]
# }
#
# resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dcra" {
#   for_each                = local.aks_vmss_ids
#   name                    = "${local.audit_dcra_name}-${each.value}"
#   target_resource_id      = each.key
#   data_collection_rule_id = local.audit_dcr_id
#   description             = "idpay_audit_dcra"
#
#   depends_on = [azapi_resource.idpay_audit_dcr]
# }
#
# resource "azurerm_monitor_data_collection_rule_association" "idpay_audit_dce_association" {
#   for_each                    = local.aks_vmss_ids
#   target_resource_id          = each.key
#   data_collection_endpoint_id = local.audit_dce_id
#   description                 = "idpay_audit_dce_association"
#
#   depends_on = [azurerm_monitor_data_collection_endpoint.idpay_audit_dce]
# }
