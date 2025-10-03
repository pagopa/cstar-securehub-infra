{
    "name": "CosmosRdbProducts",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_CosmosDb_rdb}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "CosmosDbMongoDbApiCollection",
        "schema": [],
        "typeProperties": {
            "collection": "product"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
