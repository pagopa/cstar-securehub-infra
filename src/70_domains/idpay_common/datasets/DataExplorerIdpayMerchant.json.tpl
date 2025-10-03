{
    "name": "DataExplorerIdpayMerchant",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_Kusto_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "AzureDataExplorerTable",
        "schema": [],
        "typeProperties": {
            "table": "merchant"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
