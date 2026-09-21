removed {
  from = azurerm_data_factory_linked_service_key_vault.domain_kv

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_data_factory_linked_custom_service.adf_cosmosdb_test_linked_service

  lifecycle {
    destroy = false
  }
}

removed {
  from = azurerm_data_factory_linked_custom_service.adf_cosmosdb_rtp_test_linked_service

  lifecycle {
    destroy = false
  }
}

