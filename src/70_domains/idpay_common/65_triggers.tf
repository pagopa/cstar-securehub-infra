locals {
  pipelines = {
    trigger_products          = "RdbProductCopy"
    trigger_merchant          = "IdpayMerchantCopy"
    trigger_merchant_counters = "IdpayMerchantCountersCopy"
    trigger_pos               = "IdpayPoSCopy"
  }
}

resource "azurerm_data_factory_trigger_schedule" "daily_triggers" {
  for_each        = local.pipelines
  name            = "Trigger-${each.value}"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  activated       = true
  interval        = 1
  frequency       = "Day"
  start_time      = "2025-10-08T08:12:00Z"
  time_zone       = "W. Europe Standard Time"

  pipeline {
    name = each.value
  }

  schedule {
    hours   = [0]
    minutes = [0]
  }
}
