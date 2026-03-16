{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 11,
      "content": {
        "version": "LinkItem/1.0",
        "style": "tabs",
        "links": [
          {
            "id": "ddde8bae-1136-42ce-acff-959cdd9b79d8",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Panoramica API EMD",
            "subTarget": "emd",
            "style": "emd"
          },
          {
            "id": "5c0b7a34-3f4a-4a42-94cf-27b6a68a7f10",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Monitoraggio Errori",
            "subTarget": "errors",
            "style": "error"
          },
          {
            "id": "8e6b9f72-42f3-4c7c-b3f3-8f1a5e6f2a7b",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Monitoraggio Prestazioni",
            "subTarget": "performance",
            "style": "performance"
          },
          {
            "id": "auth-tab-001",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Autenticazione",
            "subTarget": "autenticazione",
            "style": "auth"
          },
          {
            "id": "4022173b-f167-402f-a7fa-63dfb9e39469",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Attivazione / Disattivazione",
            "subTarget": "attivazioni",
            "style": "link"
          },
          {
            "id": "7da01ac5-a4a8-4dc2-8a5e-c9a5b8a399b8",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Gestione MSG",
            "subTarget": "msg",
            "style": "link"
          },
          {
            "id": "c3c876c5-f946-4b64-bf17-410815044355",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Pagamenti",
            "subTarget": "pagamenti",
            "style": "link"
          }
        ]
      },
      "name": "Collegamenti - 0"
    },
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "59922e7a-c4cd-45ce-817e-d22bb63909e1",
            "version": "KqlParameterItem/1.0",
            "name": "evaluation_window",
            "label": "Finestra di valutazione",
            "type": 4,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 3600000
                },
                {
                  "durationMs": 86400000
                },
                {
                  "durationMs": 259200000
                },
                {
                  "durationMs": 604800000
                },
                {
                  "durationMs": 1209600000
                },
                {
                  "durationMs": 2592000000
                }
              ]
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 604800000
            }
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.operationalinsights/workspaces"
      },
      "name": "Parametri - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Panoramica API",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n// Filtra per entrambe le stringhe\n| where Message contains \"Error while checking fiscal code for recipient\"\n// Raggruppa per ora e usa countif() per creare colonne separate\n| summarize\n    Error = count()\n  by bin(TimeGenerated, 1h) // Raggruppa per intervalli di 1 ora\n// Ordina per tempo\n| order by TimeGenerated asc\n// Renderizza come istogramma verticale\n| render columnchart",
              "size": 0,
              "title": "Messaggi in arrivo - ERRORI",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "barchart"
            },
            "name": "Esiti sendMessage - Messaggi in arrivo Errori"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "emd"
      },
      "name": "Panoramica API"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Monitoraggio Errori",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| where httpStatus_d !in (200, 202)\n| summarize count() by tostring(httpStatus_d)\n",
              "size": 0,
              "title": "Errori Totali API",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "piechart"
            },
            "name": "Errori Totali API"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "errors"
      },
      "name": "Monitoraggio Errori"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Monitoraggio Prestazioni",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has 'emd/message-core/sendMessage'\n| summarize avgLatency = avg(timeTaken_d) by bin(TimeGenerated, 1h)",
              "size": 0,
              "title": "Latenza Media - sendMessage",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Latenza Media - sendMessage"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has 'emd/mil/citizen/' and httpMethod_s has 'PUT'\n| summarize avgLatency = avg(timeTaken_d) by bin(TimeGenerated, 1h)",
              "size": 0,
              "title": "Latenza Media - stateSwitch",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Latenza Media - stateSwitch"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| extend normalizedUri = case(\n    requestUri_s has \"emd/message-core/sendMessage\", \"emd/message-core/sendMessage\",\n    requestUri_s has \"emd/mil/citizen/\", \"emd/mil/citizen/\",\n    requestUri_s has \"emd/citizen/\", \"emd/citizen/\",\n    requestUri_s\n)\n| summarize totalRequests = count() by bin(TimeGenerated, 1h), normalizedUri\n| order by bin(TimeGenerated, 1h)",
              "size": 0,
              "title": "Volume Richieste nel Tempo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Volume Richieste nel Tempo"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\" or requestUri_s has \"emd/citizen/\"\n| where httpStatus_d !in (200,202)\n| summarize errorCount = count() by clientIP_s\n| top 10 by errorCount\n",
              "size": 0,
              "title": "Top IP Client con Errori",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "table",
              "sortBy": [],
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "errorCount",
                "sizeAggregation": "Sum",
                "legendMetric": "errorCount",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "nodeColorField": "errorCount",
                  "colorAggregation": "Sum",
                  "type": "heatmap",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "Top IP Client con Errori"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s has \"emd/message-core/sendMessage\" or requestUri_s has \"emd/mil/citizen/\"\n| where httpStatus_d in (500)\n| summarize avgLatency = avg(timeTaken_d) by bin(TimeGenerated, 1h)\n",
              "size": 0,
              "title": "Correlazione Latenza Errori (HTTP 500)",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "linechart"
            },
            "name": "Correlazione Latenza Errori (HTTP 500)"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "performance"
      },
      "name": "Monitoraggio Prestazioni"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Autenticazione",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/auth/token'\n| project stato = tostring(serverStatus_s)\n| summarize count() by stato",
              "size": 0,
              "title": "Panoramica Token",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "piechart",
              "chartSettings": {
                "seriesLabelSettings": [
                  {
                    "seriesName": "200",
                    "color": "green"
                  },
                  {
                    "seriesName": "401",
                    "color": "redBright"
                  }
                ]
              }
            },
            "name": "Panoramica Token"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "autenticazione"
      },
      "name": "Autenticazione"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Attivazioni/Disattivazioni Cittadini",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/mil/citizen\" or Url has \"emd/citizen\"\r\n| where ResponseCode == 200\r\n| where Method has \"POST\"\r\n| count",
              "size": 0,
              "title": "✅Attivazioni con Successo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueAggregation": "None",
                "colorSettings": {
                  "type": "static",
                  "mode": "background",
                  "heatmapPalette": "greenRed",
                  "thresholdsGrid": []
                },
                "iconSettings": {
                  "thresholdsGrid": []
                },
                "tagText": "",
                "valueFontStyle": "auto",
                "numberFormatSettings": {
                  "unit": 0,
                  "options": {
                    "style": "decimal"
                  }
                }
              }
            },
            "customWidth": "20",
            "name": "Attivazioni con Successo",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/mil/citizen\" or Url has \"emd/citizen\"\r\n| where ResponseCode != 200\r\n| where Method has \"POST\"\r\n| summarize Count = count() by ResponseCode = tostring(ResponseCode)\r\n| order by ResponseCode desc",
              "size": 0,
              "showAnalytics": true,
              "title": "❌ Attivazioni Fallite per Tipo di Errore",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "piechart",
              "chartSettings": {
                "yAxis": [
                  "Count"
                ]
              }
            },
            "customWidth": "35",
            "name": "Attivazioni Fallite per Tipo di Errore",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[EMD-CITIZEN][CREATE-CITIZEN-CONSENT]\"\r\n| where Message has \"Created new citizen consent for fiscal code\"\r\n| where Message has \"tppId:\"\r\n| extend TppId = extract(\"tppId: ([^\\\\s,}]+)\", 1, Message)\r\n| extend TppName = case(\r\n    TppId contains \"bc1c40d0-f421-424f-bfd2-72246100811f-1751987878630\", \"Banca del Fucino\",\r\n    TppId contains \"cdd6dced-072f-417d-a905-bf6e7b2509cb-1758014997678\", \"HYPE\",\r\n    TppId contains \"2d59ed62-c05c-414d-a80d-3823f011c837-1743427060887\", \"emd-tpp-test\",\r\n    \"\"  // default\r\n)\r\n| where isnotempty(TppId)\r\n| summarize Attivazioni = count() by TppName, TppId\r\n| order by Attivazioni desc",
              "size": 0,
              "showAnalytics": true,
              "title": "Attivazioni suddivise per TPP",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "table",
              "gridSettings": {
                "sortBy": [
                  {
                    "itemKey": "Attivazioni",
                    "sortOrder": 1
                  }
                ]
              },
              "sortBy": [
                {
                  "itemKey": "Attivazioni",
                  "sortOrder": 1
                }
              ],
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "TppId",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Attivazioni",
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
              "graphSettings": {
                "type": 0,
                "topContent": {
                  "columnMatch": "TppId",
                  "formatter": 1
                },
                "centerContent": {
                  "columnMatch": "Attivazioni",
                  "formatter": 1,
                  "numberFormat": {
                    "unit": 17,
                    "options": {
                      "maximumSignificantDigits": 3,
                      "maximumFractionDigits": 2
                    }
                  }
                }
              }
            },
            "customWidth": "45",
            "name": "Attivazioni suddivise per TPP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/mil/citizen\" or Url has \"emd/citizen\"\r\n| where Method has \"POST\"\r\n| summarize \r\n    Successo = countif(ResponseCode == 200),\r\n    Fallimento = countif(ResponseCode != 200)\r\n  by bin(TimeGenerated, 1h)\r\n| project TimeGenerated, Successo, Fallimento",
              "size": 0,
              "title": "Andamento Temporale Attivazioni",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "timechart"
            },
            "name": "Andamento Temporale Attivazioni",
            "styleSettings": {
              "showBorder": true
            }
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "attivazioni"
      },
      "name": "Attivazioni/Disattivazioni Cittadini"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Gestione MSG",
        "items": [
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Messaggi ricevuti da SEND",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/message-core/sendMessage\"\r\n| where isnotempty(ResponseCode)\r\n| count",
                    "size": 0,
                    "title": "Totali Messaggi ricevuti ",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "graphSettings": {
                      "type": 0,
                      "topContent": {
                        "columnMatch": "TotaleInviiString",
                        "formatter": 1
                      },
                      "centerContent": {
                        "columnMatch": "TotaleInvii",
                        "formatter": 1,
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "statSettings": {
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal",
                          "useGrouping": false
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "name": "Totali Messaggi ricevuti ",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/message-core/sendMessage\"\r\n| where ResponseCode == 200\r\n| count",
                    "size": 0,
                    "title": "✅Totali messaggi accettati",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "statSettings": {
                      "valueField": "Count",
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal"
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "customWidth": "33.3",
                  "name": "Totali messaggi accettati",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/message-core/sendMessage\"\r\n| where ResponseCode == 202\r\n| count",
                    "size": 0,
                    "title": "Totali messaggi scartati",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "statSettings": {
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal"
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "customWidth": "33.3",
                  "name": "Totali messaggi scartati",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/message-core/sendMessage\"\r\n| where ResponseCode != 200 and ResponseCode != 202\r\n| summarize count() by tostring(toint(ResponseCode))",
                    "size": 0,
                    "showAnalytics": true,
                    "title": "❌ Panoramica status code errori",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "piechart"
                  },
                  "customWidth": "33.3",
                  "name": "Panoramica status code errori",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "ApiManagementGatewayLogs\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Url has \"emd/message-core/sendMessage\"\r\n| summarize \r\n    Accettati = countif(ResponseCode == 200),\r\n    Scartati = countif(ResponseCode == 202),\r\n    Errori = countif(ResponseCode != 200 and ResponseCode != 202)\r\n  by bin(TimeGenerated, 1h)\r\n| project TimeGenerated, Accettati, Scartati, Errori\r\n| render timechart",
                    "size": 0,
                    "title": "Andamento Temporale ricevimento SEND",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "timechart",
                    "chartSettings": {
                      "xSettings": {
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
                  "name": "Andamento Temporale ricevimento SEND"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "tab",
              "comparison": "isEqualTo",
              "value": "msg"
            },
            "name": "Messaggi ricevuti da SEND",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Messaggi inviati a TPP",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where (\r\n    (Message has \"[NOTIFY-SERVICE]\" and Message has \"sent. TPP responded.\")\r\n    or \r\n    (Message has \"[NOTIFY-ERROR-PRODUCER-SERVICE][ENQUEUE-NOTIFY]\" and Message has \"exceeds max retry attempts\")\r\n)\r\n| count\r\n",
                    "size": 0,
                    "title": "Totale invii a TPP",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "graphSettings": {
                      "type": 0,
                      "topContent": {
                        "columnMatch": "TotaleInviiString",
                        "formatter": 1
                      },
                      "centerContent": {
                        "columnMatch": "TotaleInvii",
                        "formatter": 1,
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "statSettings": {
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal"
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "customWidth": "33.3",
                  "name": "Totali",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[NOTIFY-SERVICE][TO-URL]\"\r\n| where Message has \"sent. TPP responded.\"\r\n| count",
                    "size": 0,
                    "title": "✅Invii a TPP con successo",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "statSettings": {
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal"
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "customWidth": "33.3",
                  "name": "Accettati",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[NOTIFY-ERROR-PRODUCER-SERVICE][ENQUEUE-NOTIFY]\" and Message has \"exceeds max retry attempts\"\r\n| count",
                    "size": 0,
                    "showAnalytics": true,
                    "title": "❌Invii a TPP falliti",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "stat",
                    "statSettings": {
                      "valueAggregation": "None",
                      "colorSettings": {
                        "type": "static",
                        "mode": "background",
                        "heatmapPalette": "greenRed",
                        "thresholdsGrid": []
                      },
                      "iconSettings": {
                        "thresholdsGrid": []
                      },
                      "numberFormatSettings": {
                        "unit": 0,
                        "options": {
                          "style": "decimal"
                        }
                      },
                      "tagText": "",
                      "valueFontStyle": "auto"
                    }
                  },
                  "customWidth": "33.3",
                  "name": "Errori",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[NOTIFY-SERVICE][TO-URL] Failed MsgId:\"\r\n| extend [\"TPP Entity ID\"] = extract(\"Tpp: ([^\\\\s,}.]+)\", 1, Message)\r\n//hardcoded names of bank\r\n| extend [\"TPP Name\"] = case(\r\n    [\"TPP Entity ID\"] contains \"04256050875\", \"Banca del Fucino\",\r\n    [\"TPP Entity ID\"] contains \"02686590023\", \"HYPE\",\r\n    [\"TPP Entity ID\"] contains \"15376371009\", \"emd-tpp-test\",\r\n    \"\"  // default\r\n)\r\n| extend [\"Message ID\"] = extract(\"MsgId: ([^\\\\s,}]+)\", 1, Message)\r\n| extend Reason = extract(\"Reason: (.+)$\", 1, Message)\r\n| summarize \r\n    Attempts = count()\r\n    by [\"TPP Name\"], [\"TPP Entity ID\"], Reason\r\n//Take only the one with more than 3 attemps\r\n| where Attempts > 3\r\n//Show only this collumn\r\n| project [\"TPP Name\"], [\"TPP Entity ID\"], Attempts, Reason\r\n| order by [\"TPP Name\"] desc, [\"TPP Entity ID\"] desc",
                    "size": 0,
                    "title": "Errori invio messaggio Tpp",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "table",
                    "gridSettings": {
                      "formatters": [
                        {
                          "columnMatch": "Reason",
                          "formatter": 0,
                          "formatOptions": {
                            "customColumnWidthSetting": "700px"
                          }
                        },
                        {
                          "columnMatch": "Reasons",
                          "formatter": 0,
                          "formatOptions": {
                            "customColumnWidthSetting": "700px"
                          }
                        }
                      ]
                    }
                  },
                  "name": "Errori invio messaggio Tpp",
                  "styleSettings": {
                    "showBorder": true
                  }
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| summarize \r\n    Successi = countif(\r\n        Message has \"[NOTIFY-SERVICE]\" \r\n        and Message has \"sent. TPP responded.\"\r\n    ),\r\n    Fallimenti = countif(\r\n        Message has \"[NOTIFY-ERROR-PRODUCER-SERVICE][ENQUEUE-NOTIFY]\" \r\n        and Message has \"exceeds max retry attempts\"\r\n    )\r\n    by bin(TimeGenerated, 1h)\r\n| project TimeGenerated, Successi, Fallimenti\r\n| order by TimeGenerated asc\r\n| render timechart",
                    "size": 0,
                    "title": "Andamento Temporale Invio TPP",
                    "queryType": 0,
                    "resourceType": "microsoft.operationalinsights/workspaces",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                    ],
                    "visualization": "timechart"
                  },
                  "name": "Andamento Temporale Invio TPP"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "tab",
              "comparison": "isEqualTo",
              "value": "msg"
            },
            "name": "Messaggi inviati a TPP",
            "styleSettings": {
              "showBorder": true
            }
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "msg"
      },
      "name": "Gestione MSG"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Pagamenti",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[EMD][PAYMENT][SAVE-RETRIEVAL] Saved retrieval:\"\r\n| extend RetrievalId = extract(\"Saved retrieval: ([^\\\\s]+)\", 1, Message)\r\n| extend EntityId = extract(\"for entityId:([^\\\\s]+)\", 1, Message)\r\n| extend Agent = extract(\"and agent: ([^\\\\s]+)\", 1, Message)\r\n| extend TppName = case(\r\n    EntityId contains \"04256050875\", \"Banca del Fucino\",\r\n    EntityId contains \"02686590023\", \"HYPE\",\r\n    EntityId contains \"15376371009\", \"emd-tpp-test\",\r\n    \"\"  // default\r\n)\r\n| summarize \r\n    RetrievalCount = dcount(RetrievalId)\r\n    by TppName, EntityId, Agent\r\n| order by EntityId desc, Agent desc",
              "size": 0,
              "title": "RetrievalId staccati",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "table",
              "gridSettings": {
                "filter": true
              }
            },
            "name": "RetrievalId staccati",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\r\n| where TimeGenerated {evaluation_window:query}\r\n| where Message has \"[EMD][PAYMENT][GET-REDIRECT] Get redirect for retrievalId:\"\r\n| extend [\"Retrieval ID\"] = extract(\"retrievalId: ([^,]+)\", 1, Message)\r\n| extend [\"Notice Number\"] = extract(\"noticeNumber: ([^a]+)\", 1, Message)\r\n| where isnotempty([\"Retrieval ID\"]) and isnotempty([\"Notice Number\"])\r\n| summarize \r\n    [\"Numero Tentativi\"] = count(),\r\n    [\"Primo Tentativo\"] = min(TimeGenerated),\r\n    [\"Ultimo Tentativo\"] = max(TimeGenerated)\r\n  by [\"Retrieval ID\"], [\"Notice Number\"]\r\n| where [\"Numero Tentativi\"] > 3\r\n| order by [\"Numero Tentativi\"] desc",
              "size": 0,
              "title": "Tentativi Pagamenti",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "table",
              "gridSettings": {
                "filter": true
              }
            },
            "name": "Tentativi Pagamenti",
            "styleSettings": {
              "showBorder": true
            }
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "pagamenti"
      },
      "name": "Pagamenti"
    }
  ]
}
