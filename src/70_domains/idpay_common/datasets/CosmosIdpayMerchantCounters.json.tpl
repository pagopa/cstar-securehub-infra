{
    "name": "CosmosIdpayMerchantCounters",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_CosmosDb_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "CosmosDbMongoDbApiCollection",
        "schema": [],
        "typeProperties": {
            "collection": "merchant_initiative_counters"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
