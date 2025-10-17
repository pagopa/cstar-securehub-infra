{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Activator",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppDependencies\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Target == 'mongodb | activation'\n| summarize count() by tostring(Success)",
          "size": 0,
          "title": "False = save già presenti nel DB. I False rappresentano tentativi di salvataggio di record già presenti.",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ],
          "visualization": "categoricalbar",
          "tileSettings": {
            "showBorder": false,
            "titleContent": {
              "columnMatch": "Success",
              "formatter": 1
            },
            "leftContent": {
              "columnMatch": "count_",
              "formatter": 12,
              "formatOptions": {
                "palette": "auto"
              },
              "numberFormat": {
                "unit": 17,
                "options": {
                  "maximumSignificantDigits": 3,
                  "maximumFractionDigits": 2
                }
              }
            }
          },
          "chartSettings": {
            "ySettings": {
              "numberFormatSettings": {
                "unit": 0,
                "options": {
                  "style": "decimal",
                  "useGrouping": true
                }
              }
            }
          }
        },
        "name": "Esito accessi a MongoDB"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook9ee57fd6-b139-4730-ac8b-ae263ee8cb58",
          "version": "MetricsItem/2.0",
          "size": 1,
          "chartType": 0,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
              "aggregation": 7,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5,
              "columnName": "Mongo Client Requests"
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
              "aggregation": 4,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
              "aggregation": 4,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
              "aggregation": 4,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
              "aggregation": 3,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
              "aggregation": 3,
              "splitBy": [
                "CollectionName"
              ],
              "splitBySortOrder": -1,
              "splitByLimit": 5,
              "columnName": "Highest RU Consuming Shard"
            }
          ],
          "title": "Cosmos DB Account Metrics By Collection",
          "gridFormatType": 2,
          "filters": [
            {
              "id": "1",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "2",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            }
          ],
          "showExpandCollapseGrid": true,
          "gridSettings": {
            "formatters": [
              {
                "columnMatch": "$gen_group",
                "formatter": 13,
                "formatOptions": {
                  "linkTarget": "Resource",
                  "showIcon": true
                }
              },
              {
                "columnMatch": "Subscription",
                "formatter": 5
              },
              {
                "columnMatch": "Name",
                "formatter": 5
              },
              {
                "columnMatch": "Segment",
                "formatter": 5
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-TotalRequests",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "blue",
                  "aggregation": "Sum"
                },
                "numberFormat": {
                  "unit": 17,
                  "options": {
                    "style": "decimal",
                    "useGrouping": false,
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-TotalRequests Timeline",
                "formatter": 9,
                "formatOptions": {
                  "min": 0,
                  "palette": "blue",
                  "aggregation": "Sum"
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "yellow",
                  "aggregation": "Sum"
                },
                "numberFormat": {
                  "unit": 17,
                  "options": {
                    "style": "decimal",
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "green",
                  "aggregation": "Sum"
                },
                "numberFormat": {
                  "unit": 2,
                  "options": {
                    "style": "decimal",
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DataUsage Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "green",
                  "aggregation": "Sum"
                },
                "numberFormat": {
                  "unit": 2,
                  "options": {
                    "style": "decimal",
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "purple",
                  "aggregation": "Max"
                },
                "numberFormat": {
                  "unit": 17,
                  "options": {
                    "style": "decimal",
                    "useGrouping": false,
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "palette": "blue",
                  "aggregation": "Max"
                },
                "numberFormat": {
                  "unit": 1,
                  "options": {
                    "style": "decimal",
                    "maximumFractionDigits": 1
                  }
                }
              },
              {
                "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "Mongo Client Requests Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "Highest RU Consuming Shard Timeline",
                "formatter": 5
              },
              {
                "columnMatch": "Highest RU Consuming Shard",
                "formatter": 1,
                "numberFormat": {
                  "unit": 1,
                  "options": null
                }
              },
              {
                "columnMatch": "Mongo Client Requests",
                "formatter": 1,
                "numberFormat": {
                  "unit": 0,
                  "options": null
                }
              }
            ],
            "rowLimit": 10000,
            "filter": true,
            "hierarchySettings": {
              "treeType": 1,
              "groupBy": [
                "Name"
              ],
              "expandTopLevel": true,
              "finalBy": "Segment"
            },
            "labelSettings": [
              {
                "columnId": "Subscription",
                "label": "Subscription/Database/Collection"
              },
              {
                "columnId": "Name",
                "label": "Collections"
              },
              {
                "columnId": "Segment",
                "label": "Collection"
              },
              {
                "columnId": "Mongo Client Requests",
                "label": "Mongo Client Requests"
              },
              {
                "columnId": "Mongo Client Requests Timeline",
                "label": "Mongo Client Requests Timeline"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                "label": "Document Count (Avg)"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount Timeline",
                "label": "Document Count (Avg) Timeline"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                "label": "Data Usage (Average)"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage Timeline",
                "label": "Data Usage (Average) Timeline"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                "label": "Index Usage (Average)"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage Timeline",
                "label": "Index Usage (Average) Timeline"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
                "label": "Provisioned Throughput (Max)"
              },
              {
                "columnId": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput Timeline",
                "label": "Provisioned Throughput (Max) Timeline"
              },
              {
                "columnId": "Highest RU Consuming Shard",
                "label": "Highest RU Consuming Shard"
              },
              {
                "columnId": "Highest RU Consuming Shard Timeline",
                "label": "Highest RU Consuming Shard Timeline"
              }
            ]
          },
          "sortBy": [],
          "showExportToExcel": true
        },
        "showPin": false,
        "name": "CosmosDB Account Metrics"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook859d09ea-f343-478c-a0a0-5eaf79f8ac34",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "timeGrain": "PT1H",
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
              "aggregation": 3,
              "splitBy": [
                "CollectionName"
              ]
            }
          ],
          "title": "Highest RU Consuming Shard Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "2",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "showPin": false,
        "name": "NormalizedRUConsumption"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbookaf172b5e-e51e-4ea3-a191-0de5841b33b6",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
              "aggregation": 1
            }
          ],
          "title": "Total RUs Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "2",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "showPin": false,
        "name": "metric - 5"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook2a2620ac-8baa-40e1-98cf-4ebad54f82db",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
              "aggregation": 1,
              "splitBy": [
                "OperationType"
              ]
            }
          ],
          "title": "Total RUs by Request Type",
          "filters": [
            {
              "id": "1",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            },
            {
              "id": "2",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "name": "metric - 10"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbookb53a712c-9e6d-424b-a727-0744595027dc",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
              "aggregation": 7,
              "splitBy": [
                "CommandName"
              ],
              "columnName": "MongoDB Client Requests"
            }
          ],
          "title": "Client Requests Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "2",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "name": "metric - 3"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook70c7cafe-2575-4902-8651-b9ca636916bf",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
              "aggregation": 7,
              "splitBy": [
                "CommandName"
              ]
            }
          ],
          "title": "Failed Client Requests by Operation Type Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "2",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "3",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            },
            {
              "id": "4",
              "key": "ErrorCode",
              "operator": 1,
              "values": [
                "0"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "name": "metric - 4"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook9108a8f3-b930-46e6-a394-50417a940b87",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
              "aggregation": 1
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
              "aggregation": 1
            }
          ],
          "title": "Data & Index Usage",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            },
            {
              "id": "2",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "name": "metric - 6"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbook7eaa1654-64ba-4205-9242-e0d2fb8f3078",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
              "aggregation": 4
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
              "aggregation": 2
            },
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
              "aggregation": 3
            }
          ],
          "title": "Service Availability (min/max/avg in %)",
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "showPin": false,
        "name": "metric - 7"
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbookc56eee42-75de-44f2-a40d-45c819821abd",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ServerSideLatencyGateway",
              "aggregation": 4,
              "splitBy": [
                "Region"
              ]
            }
          ],
          "title": "Server Side Latency (Avg) By Region Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            },
            {
              "id": "2",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "3",
              "key": "PublicAPIType",
              "operator": 0,
              "values": [
                "mongoDB"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "customWidth": "50",
        "name": "metric - 8",
        "styleSettings": {
          "maxWidth": "50",
          "showBorder": true
        }
      },
      {
        "type": 10,
        "content": {
          "chartId": "workbookfb6f57e3-8351-40e2-925e-0883851350ff",
          "version": "MetricsItem/2.0",
          "size": 0,
          "chartType": 2,
          "resourceType": "microsoft.documentdb/databaseaccounts",
          "metricScope": 0,
          "resourceIds": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
          ],
          "timeContextFromParameter": "evaluation_window",
          "timeContext": {
            "durationMs": 604800000
          },
          "metrics": [
            {
              "namespace": "microsoft.documentdb/databaseaccounts",
              "metric": "microsoft.documentdb/databaseaccounts-Requests-ServerSideLatencyGateway",
              "aggregation": 4,
              "splitBy": [
                "OperationType"
              ]
            }
          ],
          "title": " Server Side Latency (Avg) By Operation Activation - activations/deleted-activations",
          "showOpenInMe": true,
          "filters": [
            {
              "id": "1",
              "key": "DatabaseName",
              "operator": 0,
              "values": [
                "activation"
              ]
            },
            {
              "id": "2",
              "key": "CollectionName",
              "operator": 0,
              "values": [
                "activations",
                "deleted_activations"
              ]
            },
            {
              "id": "3",
              "key": "PublicAPIType",
              "operator": 0,
              "values": [
                "mongoDB"
              ]
            }
          ],
          "gridSettings": {
            "rowLimit": 10000
          }
        },
        "customWidth": "50",
        "name": "metric - 9",
        "styleSettings": {
          "maxWidth": "50",
          "showBorder": true
        }
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "activator"
  },
  "name": "Activator"
}
