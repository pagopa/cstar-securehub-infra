{
    "name": "CosmosIdpayPoS",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_CosmosDb_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "CosmosDbMongoDbApiCollection",
        "schema": [],
        "typeProperties": {
            "collection": "point_of_sales"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
