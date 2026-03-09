locals {
  collections = [
    {
      name = "citizen_consents"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["fiscalCode"]
          unique = true
        },
        {
          keys   = ["consents.$**"]
          unique = false
        }
      ]
    },
    {
      name = "tpp"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "entityId"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = true
        },
        {
          keys   = ["entityId"]
          unique = true
        }
      ]

    },
    {
      name = "message"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["entityId"]
          unique = false
        },
        {
          keys   = ["recipientId"]
          unique = false
        },
        {
          keys   = ["messageId", "entityId"]
          unique = true
        },
        {
          keys   = ["originId"]
          unique = false
        }
      ]

    },
    {
      name = "retrieval"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["retrievalId"]
          unique = true
        }
      ]
    },
    {
      name = "payment_attempt"
      indexes = [{
        keys   = ["_id"]
        unique = true
        },
        {
          keys   = ["tppId", "originId", "fiscalCode"]
          unique = true
        },
        {
          keys   = ["tppId"]
          unique = false
        },
        {
          keys   = ["originId"]
          unique = false
        },
        {
          keys   = ["fiscalCode"]
          unique = false
        }
      ]
    }
  ]
}
