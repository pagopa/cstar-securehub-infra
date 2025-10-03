{
    "name": "DataExplorerIdpayPoS",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_Kusto_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "AzureDataExplorerTable",
        "schema": [],
        "typeProperties": {
            "table": "point_of_sales"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
