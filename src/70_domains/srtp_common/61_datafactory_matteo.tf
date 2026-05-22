### test matteo

resource "azurerm_data_factory_linked_custom_service" "cosmos_mongo" {

  name            = "ls_cosmosdb_mongo_matteo"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  type            = "CosmosDbMongoDbApi"
  type_properties_json = jsonencode({
    connectionString       = module.cosmos_db_account.primary_connection_strings
    account                = module.cosmos_db_account.name
    database               = "rtp"
    isServerVersionAbove32 = true
  })

  integration_runtime {
    name = "AutoResolveIntegrationRuntime"
  }
}


resource "azapi_resource" "source_dataset" {
  name      = "mongosourceMatteo"
  parent_id = data.azurerm_data_factory.data_factory.id
  type      = "Microsoft.DataFactory/factories/datasets@2018-06-01"

  body = {
    properties = {
      description = "My MongoDB database 'srtp' collection 'rtps' dataset"
      type        = "CosmosDbMongoDbApiCollection"

      linkedServiceName = {
        referenceName = azurerm_data_factory_linked_custom_service.cosmos_mongo.name
        type          = "LinkedServiceReference"
      }

      typeProperties = {
        collection = "rtps"
      }
    }
  }
}

resource "azapi_resource" "sink_dataset" {
  name      = "mongosinkMatteo"
  parent_id = data.azurerm_data_factory.data_factory.id
  type      = "Microsoft.DataFactory/factories/datasets@2018-06-01"

  body = {
    properties = {
      description = "My MongoDB database 'srtp' collection 'rtps' dataset"
      type        = "CosmosDbMongoDbApiCollection"

      linkedServiceName = {
        referenceName = azurerm_data_factory_linked_custom_service.cosmos_mongo.name
        type          = "LinkedServiceReference"
      }

      typeProperties = {
        collection = "rtps"
      }
    }
  }
}


resource "azurerm_data_factory_data_flow" "update_ttl" {
  name            = "df_UpdateCosmosDbTTL_Matteo"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  description     = "Filtra i documenti Cosmos DB per condizione su un campo e aggiorna il campo _ttl"

  source {
    name        = "sourceCosmosDb"
    description = "Legge tutti i documenti dalla collection Cosmos DB"

    dataset {
      name = azapi_resource.source_dataset.name
    }
  }

  sink {
    name        = "sinkCosmosDb"
    description = "Upsert su Cosmos DB: aggiorna solo il campo _ttl usando _id come chiave"

    dataset {
      name = azapi_resource.sink_dataset.name
    }
  }

  # Script del Data Flow in formato ADF (linguaggio proprietario).
  # Le espressioni usano variabili Terraform interpolate a deploy-time.
  script = <<-SCRIPT
    source(allowSchemaDrift: true,
        validateSchema: false,
        enableChangeFeed: false,
        format: 'document') ~> sourceCosmosDb

  SCRIPT
}

# Pipeline principale che esegue il Data Flow
resource "azurerm_data_factory_pipeline" "update_ttl" {
  name            = "pl_UpdateCosmosDbTTL_Matteo"
  data_factory_id = data.azurerm_data_factory.data_factory.id
  description     = "Aggiorna il campo _ttl su Cosmos DB for MongoDB in base a condizioni sul documento"

  activities_json = jsonencode([
    {
      name = "ExecuteUpdateTTLFlow_Matteo"
      type = "ExecuteDataFlow"
      typeProperties = {
        dataFlow = {
          referenceName = azurerm_data_factory_data_flow.update_ttl.name
          type          = "DataFlowReference"
        }
        # Cluster General Purpose 8 core — adatto per volumi < 1.000 doc
        compute = {
          coreCount     = 2
          computeType   = "General"
        }
        # Auto-terminate dopo 10 minuti di idle per ridurre i costi
        traceLevel = "Fine"
      }
      policy = {
        timeout                = "0.01:00:00" # 1 ora max
        retry                  = 1
        retryIntervalInSeconds = 30
        secureOutput           = false
        secureInput            = false
      }
    }
  ])
}


# # Trigger di schedulazione (ogni N minuti, configurabile via variabile)
# resource "azurerm_data_factory_trigger_schedule" "update_ttl_schedule" {
#   name            = "trg_UpdateCosmosDbTTL_Schedule"
#   data_factory_id = data.azurerm_data_factory.data_factory.id
#   pipeline_name   = azurerm_data_factory_pipeline.update_ttl.name

#   interval  = var.pipeline_schedule_interval
#   frequency = "Minute"

#   # Il trigger parte attivo; mettilo a false se vuoi deployare in pausa
#   activated = true

#   annotations = []
# }