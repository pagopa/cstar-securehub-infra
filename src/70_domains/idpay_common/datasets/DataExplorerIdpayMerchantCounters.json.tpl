{
    "name": "DataExplorerIdpayMerchantCounters",
    "properties": {
        "linkedServiceName": {
            "referenceName": "${linkedService_Kusto_idpay}",
            "type": "LinkedServiceReference"
        },
        "annotations": [],
        "type": "AzureDataExplorerTable",
        "schema": [],
        "typeProperties": {
            "table": "merchant_initiative_counters"
        }
    },
    "type": "Microsoft.DataFactory/factories/datasets"
}
