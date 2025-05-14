prefix             = "cstar"
env_short          = "u"
env                = "uat"
domain             = "idpay"
location           = "italynorth"
location_short     = "itn"
location_weu       = "westeurope"
location_short_weu = "weu"

#
# Dns
#
dns_zone_prefix          = "uat.cstar"
dns_zone_internal_prefix = "internal.uat.cstar"
external_domain          = "pagopa.it"

tags = {
  CreatedBy   = "Terraform"
  Environment = "Uat"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-infrastructure"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
  Application = "IdPay"
}

#
# CIDRs
#
cidr_idpay_data_cosmos     = ["10.20.10.0/27"]  # 10.20.10.0 -> 10.20.10.31
cidr_idpay_data_eventhub   = ["10.20.10.32/27"] # 10.20.10.32 -> 10.20.10.63
cidr_idpay_data_redis      = ["10.20.10.64/27"] # 10.20.10.64 -> 10.20.10.95
cidr_idpay_data_servicebus = ["10.20.10.96/27"] # 10.20.10.96 -> 10.20.10.127

rtd_keyvault = {
  name           = "cstar-u-rtd-kv"
  resource_group = "cstar-u-rtd-sec-rg"
}

cosmos_mongo_account_params = {
  enabled      = true
  capabilities = ["EnableMongo"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "Strong"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  server_version                   = "7.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  additional_geo_locations          = []
  private_endpoint_enabled          = true
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = false

  backup_continuous_enabled = false
}

cosmos_mongo_db_idpay_params = {
  throughput     = null
  max_throughput = 1000
}

#
# Redis
#
redis_params = {
  sku_name = "Basic"
  family   = "C"
  capacity = 1
}

#
# Service bus
#
service_bus_namespace = {
  sku = "Standard"
}

##Eventhub
ehns_sku_name                 = "Standard"
ehns_capacity                 = 1
ehns_maximum_throughput_units = 5
ehns_auto_inflate_enabled     = true
ehns_alerts_enabled           = false


eventhubs_idpay = [
  {
    name              = "idpay-onboarding-outcome"
    partitions        = 3
    message_retention = 1
    consumers = [
      "idpay-onboarding-outcome-consumer-group",
      "idpay-initiative-onboarding-statistics-group"
    ]
    keys = [
      {
        name   = "idpay-onboarding-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-onboarding-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-onboarding-notification"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-onboarding-notification-consumer-group"]
    keys = [
      {
        name   = "idpay-onboarding-notification-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-onboarding-notification-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-checkiban-evaluation"
    partitions        = 3
    message_retention = 1
    consumers = [
      "idpay-checkiban-evaluation-consumer-group",
      "idpay-rewards-notification-checkiban-req-group"
    ]
    keys = [
      {
        name   = "idpay-checkiban-evaluation-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-checkiban-evaluation-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-checkiban-outcome"
    partitions        = 3
    message_retention = 1
    consumers = [
      "idpay-checkiban-outcome-consumer-group",
      "idpay-rewards-notification-checkiban-out-group"
    ]
    keys = [
      {
        name   = "idpay-checkiban-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-checkiban-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-notification-request"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-notification-request-group"]
    keys = [
      {
        name   = "idpay-notification-request-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-notification-request-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-onboarding-ranking-request"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-onboarding-ranking-request-consumer-group"]
    keys = [
      {
        name   = "idpay-onboarding-ranking-request-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-onboarding-ranking-request-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-transaction"
    partitions        = 16
    message_retention = 1
    consumers = [
      "idpay-transaction-consumer-group",
      "idpay-transaction-wallet-consumer-group",
      "idpay-rewards-notification-transaction-group",
      "idpay-initiative-rewards-statistics-group",
      "idpay-reward-calculator-consumer-group"
    ]
    keys = [
      {
        name   = "idpay-transaction-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-transaction-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
]

eventhubs_idpay_01 = [
  {
    name              = "idpay-rule-update"
    partitions        = 3
    message_retention = 1
    consumers = [
      "idpay-beneficiary-rule-update-consumer-group",
      "idpay-reward-calculator-rule-consumer-group",
      "idpay-rewards-notification-rule-consumer-group"
    ]
    keys = [
      {
        name   = "idpay-rule-update-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-rule-update-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-hpan-update"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-reward-calculator-hpan-update-consumer-group"]
    keys = [
      {
        name   = "idpay-hpan-update-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-hpan-update-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-hpan-update-outcome"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-hpan-update-outcome-consumer-group"]
    keys = [
      {
        name   = "idpay-hpan-update-outcome-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-hpan-update-outcome-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-transaction-user-id-splitter"
    partitions        = 16
    message_retention = 1
    consumers         = ["idpay-reward-calculator-consumer-group"]
    keys = [
      {
        name   = "idpay-transaction-user-id-splitter-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-transaction-user-id-splitter-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-errors"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-errors-recovery-group"]
    keys = [
      {
        name   = "idpay-errors-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-errors-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-reward-notification-storage-events"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-reward-notification-storage-group"]
    keys = [
      {
        name   = "idpay-reward-notification-storage-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-reward-notification-storage-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-reward-notification-response"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-reward-notification-response-group"]
    keys = [
      {
        name   = "idpay-reward-notification-response-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-reward-notification-response-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-commands"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-commands-wallet-consumer-group", "idpay-commands-group-consumer-group", "idpay-commands-notification-consumer-group", "idpay-commands-ranking-consumer-group", "idpay-commands-admissibility-consumer-group", "idpay-commands-reward-calculator-consumer-group", "idpay-commands-reward-notification-consumer-group", "idpay-commands-timeline-consumer-group", "idpay-commands-onboarding-consumer-group", "idpay-commands-payment-instrument-consumer-group", "idpay-commands-statistics-consumer-group", "idpay-commands-merchant-consumer-group", "idpay-commands-payment-consumer-group", "idpay-commands-transaction-consumer-group", "idpay-commands-iban-consumer-group", "idpay-commands-initiative-consumer-group", "idpay-commands-self-expense-consumer-group"]
    keys = [
      {
        name   = "idpay-commands-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-commands-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
  {
    name              = "idpay-timeline"
    partitions        = 3
    message_retention = 1
    consumers         = ["idpay-timeline-consumer-group"]
    keys = [
      {
        name   = "idpay-timeline-producer"
        listen = false
        send   = true
        manage = false
      },
      {
        name   = "idpay-timeline-consumer"
        listen = true
        send   = false
        manage = false
      }
    ]
  },
]

### handle resource enable
enable = {
  idpay = {
    eventhub_idpay_00 = true
    eventhub_idpay_01 = true
  }
}

### AKS VNet
aks_vnet = {
  name           = "cstar-u-weu-uat01-vnet"
  resource_group = "cstar-u-weu-uat01-vnet-rg"
  subnet         = "cstar-u-weu-uat01-aks-snet"
}

aks_name                = "cstar-u-weu-uat01-aks"
aks_resource_group_name = "cstar-u-weu-uat01-aks-rg"

### CDN
idpay_cdn_storage_account_replication_type            = "ZRS"
selfcare_welfare_cdn_storage_account_replication_type = "ZRS"
robots_indexed_paths                                  = []
idpay_cdn_sa_advanced_threat_protection_enabled       = false
single_page_applications_roots_dirs = [
  "portale-enti",
  "portale-esercenti",
  "mocks/merchant",
  "ricevute"
]

# Storage
storage_account_settings = {
  delete_retention_days              = 5
  enable_versioning                  = true
  replication_type                   = "ZRS"
  advanced_threat_protection_enabled = false
}
