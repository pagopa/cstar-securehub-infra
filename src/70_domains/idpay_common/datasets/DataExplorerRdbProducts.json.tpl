{
    "name": "DataExplorerRdbProducts",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_Kusto_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "AzureDataExplorerTable",
        "schema": [],
        "typeProperties": {
            "table": "products"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
