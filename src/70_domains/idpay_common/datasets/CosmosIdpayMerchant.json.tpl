{
    "name": "CosmosIdpayMerchant",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_CosmosDb_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "CosmosDbMongoDbApiCollection",
        "schema": [],
        "typeProperties": {
            "collection": "merchant"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
