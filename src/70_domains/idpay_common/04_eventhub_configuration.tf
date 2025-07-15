locals {
  ###
  ### Eventhub IDPAY
  ###

  eventhubs_idpay_00 = [
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
      partitions        = 3
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
    {
      name              = "rtd-pi-to-app"
      message_retention = 1
      partitions        = 4
      consumers = [
        "rtd-pi-to-app-consumer-group"
      ]
      keys = [
        {
          name   = "rtd-pi-to-app-consumer-policy"
          listen = true
          send   = true
          manage = false
        },
        {
          name   = "rtd-pi-to-app-producer-policy"
          listen = false
          send   = true
          manage = false
        }
      ]
    },
    {
      name              = "rtd-pi-from-app"
      message_retention = 1
      partitions        = 4
      consumers = [
        "rtd-pi-from-app-consumer-group"
      ]
      keys = [
        {
          name   = "rtd-pi-from-app-consumer-policy"
          listen = true
          send   = true
          manage = false
        },
        {
          name   = "rtd-pi-from-app-producer-policy"
          listen = false
          send   = true
          manage = false
        }
      ]
    },
    {
      name              = "rtd-trx"
      partitions        = 1
      message_retention = 1
      consumers         = ["idpay-consumer-group"]
      keys = [
        {
          name   = "rtd-trx-consumer"
          listen = true
          send   = false
          manage = false
        },
        {
          name   = "rtd-trx-producer"
          listen = false
          send   = true
          manage = false
        },
        {
          name   = "rtd-trx-test-policy"
          listen = true
          send   = true
          manage = false
        }
      ]
    }
  ]

  ###
  ### Eventhub 01 IDPAY
  ###

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
      partitions        = 3
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
    }
  ]

  ###
  ### Eventhub 02 IDPAY
  ###
  eventhubs_idpay_02 = [
    {
      name              = "idpay-cdc-configs"
      partitions        = 1
      message_retention = 1
      consumers         = []
      keys              = []
    },
    {
      name              = "idpay-cdc-offsets"
      partitions        = 25
      message_retention = 1
      consumers         = []
      keys              = []
    },
    {
      name              = "idpay-cdc-status"
      partitions        = 5
      message_retention = 1
      consumers         = []
      keys              = []
    }
  ]

  ###
  ### Eventhub 00 IDPAY
  ###
  eventhubs_rdb = [
    {
      name              = "idpay-asset-register"
      partitions        = 3
      message_retention = 1
      consumers         = ["idpay-asset-register-consumer-group"]
      keys = [
        {
          name   = "idpay-asset-register-producer"
          listen = false
          send   = true
          manage = false
        },
        {
          name   = "idpay-asset-register-consumer"
          listen = true
          send   = false
          manage = false
        }
      ]
    }
  ]
}
