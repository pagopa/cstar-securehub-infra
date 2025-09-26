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
            "linkLabel": "Attivazioni cittadini",
            "subTarget": "attivazioni",
            "style": "link"
          },
          {
            "id": "c4773476-5d1f-413b-aa2e-b0f3ab6d96af",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Disattivazione Cittadini",
            "subTarget": "disattivazioni",
            "style": "link"
          },
          {
            "id": "3c0d8201-7d21-4cbb-8d18-53a5b14500e3",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Invii SRTP",
            "subTarget": "invii",
            "style": "link"
          },
          {
            "id": "07d1ffe5-e677-455f-86e1-6d75f3409bc9",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Cancellazioni",
            "subTarget": "cancellazione",
            "style": "link"
          },
          {
            "id": "49f84314-e3cf-4c13-80d2-fd8a5c143283",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Callback",
            "subTarget": "callback",
            "style": "link"
          },
          {
            "id": "9ebd3a62-c270-4705-908a-3cd6f4c100c3",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Accessi Account Storage",
            "subTarget": "repository",
            "style": "link"
          },
          {
            "id": "962860b7-7ab0-407b-8893-436851775e83",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Activator",
            "subTarget": "activator",
            "style": "link"
          },
          {
            "id": "e5d18498-a18c-48f7-9f42-e442d53a829f",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Sender",
            "subTarget": "sender",
            "style": "link"
          },
          {
            "id": "51582522-aadd-4ac5-9c9e-7836ee0b7124",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Autenticazione",
            "subTarget": "autenticazione",
            "style": "link"
          },
          {
            "id": "0f11a149-7af5-4433-8293-cfbb34e6241f",
            "cellValue": "tab",
            "linkTarget": "parameter",
            "linkLabel": "Monitoraggio Service Providers",
            "subTarget": "sp",
            "style": "link"
          }
        ]
      },
      "name": "links - 0"
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
            "label": "Finestra di osservabilità",
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
      "name": "parameters - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Attivazioni",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == \"/rtp/activation/activations\"\n| where toint(httpStatus_d) == 201\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)\n",
              "size": 0,
              "title": "✅ Attivazioni totali con successo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Totale",
                    "formatter": 1
                  }
                ],
                "labelSettings": [
                  {
                    "columnId": "Totale",
                    "label": "Totale delle attivazioni effettuate con successo"
                  }
                ]
              },
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Attivazioni totali",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where toint(httpStatus_d) != 201\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)\n",
              "size": 0,
              "title": "❌ Attivazioni totali fallite",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Attivazioni totali",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpMethod_s == \"POST\"\n| summarize count() by tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Panoramica delle attivazioni totali con status code",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
              "chartSettings": {
                "seriesLabelSettings": [
                  {
                    "seriesName": "True",
                    "color": "green"
                  },
                  {
                    "seriesName": "False",
                    "color": "redBright"
                  }
                ],
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
            "customWidth": "50",
            "name": "Panoramica attivazioni",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| summarize \n    Successo   = countif(httpStatus_d == 201),\n    Fallimento = countif(httpStatus_d != 201)\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
              "size": 0,
              "title": "Attivazioni nel tempo (Successi vs Fallimenti) in bin 1 ora",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "timechart",
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
            "name": "Attivazioni nel tempo (Successi vs Fallimenti)"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Payer activated with id:\"\n| extend service_provider = tostring(Properties.service_provider)\n| summarize count() by service_provider\n| project-rename \n    [\"Service Provider\"] = service_provider, \n    [\"Count\"] = count_",
              "size": 0,
              "aggregation": 5,
              "title": "✅ Attivazioni con successo per Service Provider",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "unstackedbar",
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
            "name": "Attivazioni con successo per Service Provider"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Error activating payer\"\n| extend service_provider = tostring(Properties.service_provider)\n| summarize count_ = count() by service_provider\n| project-rename \n    [\"Service Provider\"] = service_provider, \n    [\"Count\"] = count_\n",
              "size": 0,
              "aggregation": 5,
              "title": "❌ Attivazioni fallite per Service Provider",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "unstackedbar",
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
            "name": "Attivazioni fallite per Service Provider"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpStatus_d in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
              "size": 0,
              "title": "✅ Status code dei successi delle attivazioni per Client IP",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ]
            },
            "customWidth": "50",
            "name": "Status code dei successi delle attivazioni",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpStatus_d !in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
              "size": 0,
              "title": "❌ Status code dei fallimenti delle attivazioni per Client IP",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ]
            },
            "customWidth": "50",
            "name": "Status code dei fallimenti delle attivazioni",
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
      "name": "Attivazioni"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Invii SRTP",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "✅ Invii totali con successo (APIM + CODA)",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat"
            },
            "name": "✅ Invii totali con successo (APIM + CODA)",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) == 201\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
              "size": 0,
              "title": "✅ Invii totali con successo passando da APIM",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Totale",
                    "formatter": 1
                  }
                ]
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
                "tagText": "",
                "valueFontStyle": "auto",
                "valueField": "totalRequestsString"
              }
            },
            "customWidth": "25",
            "name": "Invii totali con successo ",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) !in (201,200)\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
              "size": 0,
              "title": "❌ Invii totali falliti  passando da APIM",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Invii totali falliti",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where httpMethod_s == \"POST\"\n| summarize count() by tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Panoramica degli invii totali con status code passando da APIM",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Panoramica degli invii totali con status code",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) !in (201,200,500,404,422,400)\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
              "size": 0,
              "title": "❌ Invii falliti (APIM)",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "sortBy": [],
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Invii totali falliti apim",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error finding activation data with resourceId:\" or Message startswith \"Error saving Rtp to be sent:\" or Message startswith \"Error sending Rtp to be sent:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "❌ Invii falliti da apim e da coda",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "❌ Invii falliti (Servizio)",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| extend ServiceProvider = tostring(Properties.debtor_service_provider)\n| extend ServiceProvider = iff(isempty(ServiceProvider), \"N/A\", ServiceProvider)\n| summarize retries = count() by ServiceProvider\n| order by retries desc\n",
              "size": 0,
              "title": "Retry per invii SRTP",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-core-law"
              ],
              "visualization": "table"
            },
            "customWidth": "50",
            "name": "Retry per invii SRTP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 9,
            "content": {
              "version": "KqlParameterItem/1.0",
              "parameters": [],
              "style": "pills",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces"
            },
            "name": "parameters - 10"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n and httpMethod_s == \"POST\"\n| summarize \n    Successo   = countif(httpStatus_d == 201),\n    Fallimento = countif(httpStatus_d !in (201,200))\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
              "size": 0,
              "title": "Invii nel tempo (Successi vs Fallimenti)",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "name": "Invii nel tempo (Successi vs Fallimenti)"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize \n    [\"Invii con successo\"] = count() \n  by \n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Invii con successo\"] desc\n",
              "size": 0,
              "title": "✅ Invii con successo per Service Provider del debitore",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "barchart",
              "sortBy": [],
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Debtor Service Provider",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Invii con successo",
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
                  "columnMatch": "Debtor Service Provider",
                  "formatter": 1
                },
                "centerContent": {
                  "columnMatch": "Invii con successo",
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
              },
              "mapSettings": {
                "locInfo": "LatLong",
                "sizeSettings": "Invii con successo",
                "sizeAggregation": "Sum",
                "legendMetric": "Invii con successo",
                "legendAggregation": "Sum",
                "itemColorSettings": {
                  "type": "heatmap",
                  "colorAggregation": "Sum",
                  "nodeColorField": "Invii con successo",
                  "heatmapPalette": "greenRed"
                }
              }
            },
            "name": "Invii con successo per Service Provider del debitore"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend reource_id = tostring(Properties.resource_id)\n| summarize errorCount = count() by reource_id\n| project-rename \n    [\"RTP id\"] = reource_id,\n    [\"Errori\"]              = errorCount\n| sort by [\"Errori\"] desc",
              "size": 0,
              "title": "❌ Invii falliti per RTP resource id",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
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
            "name": "Invii falliti per RTP resource id"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Rtp sent successfully with id: \"\n| summarize [\"Invii Effettuati\"] = count() by [\"Payee Name\"] = tostring(Properties.payee_name)\n| sort by [\"Invii Effettuati\"] desc\n",
              "size": 0,
              "title": "✅Invii con successo per Ente Creditore",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "customWidth": "50",
            "name": "Invii con successo per Ente Creditore",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Error finding activation data with resourceId:\" or Message startswith \"Error saving Rtp to be sent:\" or Message startswith \"Error sending Rtp to be sent:\"\n| extend payee_name = tostring(Properties.payee_name)\n| summarize [\"Errori\"] = count() by [\"Payee Name\"] = payee_name\n| sort by [\"Errori\"] desc\n",
              "size": 0,
              "title": "❌ Invii falliti per Ente Creditore",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "customWidth": "50",
            "name": "Invii falliti per Ente Creditore",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/rtps\"\n| where httpStatus_d in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
              "size": 0,
              "title": "✅ Status code dei successi degli invii per Client IP",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "table"
            },
            "customWidth": "50",
            "name": "Status code dei successi degli invii per Client IP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/rtps\"\n| where httpStatus_d !in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
              "size": 0,
              "title": "❌ Status code dei successi degli invii per Client IP",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ]
            },
            "customWidth": "50",
            "name": "Status code dei successi degli invii per Client IP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message discarded due to out of order timestamp\"\n| parse Message with \"Message discarded due to out of order timestamp: timestamp=\" timestamp \", status=\" status \", operation=\" operation \", id=\" id \", ultimoTimestamp=\" ultimoTimestamp\n| summarize errorCount = count() by timestamp, status, operation, id, ultimoTimestamp\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "❌ Messaggi scartati per Out-of-order Timestamp",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "name": "❌ Messaggi scartati per Out-of-order Timestamp"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error getting payee name from payee registry for the payee id\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "❌ Errore nel recupero del payee ID dal payee registry",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat"
            },
            "name": "❌ Errore nel recupero del payee ID dal payee registry"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message hasprefix \"Successfully got payee name\"\n| parse Message with \"Successfully got payee name \" payeeName \" for the payee id \" payeeId\n| summarize rtpCount = count(), ids = make_set(payeeId, 100) by tostring(payeeName)\n| order by rtpCount desc\n",
              "size": 0,
              "title": "✅ Successo nel recupero del payee name per payee ID",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "name": "✅ Successo nel recupero del payee name per payee ID"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "invii"
      },
      "name": "Invii SRTP"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Gestore Repository",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/payees/payees'\n| summarize Count = count() by StatusCode = tostring(toint(httpStatus_d))\n| render piechart\n",
              "size": 0,
              "title": "Panoramica degli accessi totali al Payee Registry con status code",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Panoramica degli accessi totali al Payee Registry con status code",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where Message has \"registry_access\"\n| extend d = parse_json(Message)\n| where tostring(d.resource) == \"payees\"\n| summarize Occurrencies = count() by Subject = tostring(d.sub)\n| order by Occurrencies desc",
              "size": 0,
              "title": "✅  Accessi per Subject al Payee Registry",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "customWidth": "50",
            "name": "✅  Accessi per Subject al Payee Registry",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/payees/payees'\n| summarize \n    Successo   = countif(httpStatus_d == 200),\n    Fallimento = countif(httpStatus_d != 200)\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
              "size": 0,
              "title": "Accessi al Payee Registry (Successi vs Fallimenti) in bin 1 ora",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "name": "Accessi al Payee Registry (Successi vs Fallimenti) in bin 1 ora"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/service_providers/service-providers'\n| summarize Count = count() by StatusCode = tostring(toint(httpStatus_d))\n| render piechart\n",
              "size": 0,
              "title": "Panoramica degli accessi totali al Service Registry con status code",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "customWidth": "50",
            "name": "Panoramica degli accessi totali al Service Registry con status code",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where Message has \"registry_access\"\n| extend d = parse_json(Message)\n| where tostring(d.resource) == \"service_providers\"\n| summarize Occurrencies = count() by Subject = tostring(d.sub)\n| order by Occurrencies desc\n",
              "size": 0,
              "title": "✅  Accessi per Subject al Service Registry",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "customWidth": "50",
            "name": "✅  Accessi per Subject al Service Registry",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/service_providers/service-providers'\n| summarize \n    Successo   = countif(httpStatus_d == 200),\n    Fallimento = countif(httpStatus_d != 200)\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
              "size": 0,
              "title": "Accessi al Service Registry (Successi vs Fallimenti) in bin 1 ora",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "name": "Accessi al Service Registry (Successi vs Fallimenti) in bin 1 ora"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "repository"
      },
      "name": "Gestore Repository"
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
              "query": "ApiManagementGatewayLogs\n| where TimeGenerated {evaluation_window:query}\n| where OperationId == \"getAccessTokens\"\n| mv-expand TraceRecords\n| where TraceRecords.metadata.key == \"counterKey\"\n| summarize count=count() by client_id=tostring(TraceRecords.message), ResponseCode\n| sort by client_id asc, ResponseCode asc",
              "size": 0,
              "title": "Panoramica stacco del token",
              "timeContext": {
                "durationMs": 86400000
              },
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "name": "Panoramica stacco del token"
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
        "title": "Callback",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/cb/send'\n| summarize count() by tostring(toint(httpStatus_d))\n",
              "size": 0,
              "title": "Callback totali ricevute e relativi status code",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Callback totali ricevute e relativi status code",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == \"/rtp/cb/send\"\n| where toint(httpStatus_d) != 200\n| summarize count() by tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Errori HTTP callback",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Errori HTTP callback",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message contains \"Send callback processed successfully\"\n| extend props = parse_json(Properties)\n| extend certificate_serial_number = tostring(props.certificate_serial_number)\n| summarize callbackCount = count() by certificate_serial_number\n| render table\n",
              "size": 0,
              "title": "✅ Callback per Service Provider con successo",
              "noDataMessageStyle": 5,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "unstackedbar",
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
            "name": "✅ Callback per Service Provider con successo"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Certificate mismatch: expected \"\n| extend CertificareSerialNumber = tostring(Properties.certificate_serial_number)\n| extend CertificareSerialNumber = iff(isempty(CertificareSerialNumber), \"N/A\", CertificareSerialNumber)\n| summarize [\"Numero di Mismatch\"] = count() by [\"Certificate Serial Number\"] = CertificareSerialNumber\n| order by [\"Numero di Mismatch\"] desc\n",
              "size": 4,
              "title": "Numero di mismatch del seriale del certificato",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ]
            },
            "name": "Numero di mismatch del seriale del certificato"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Certificate mismatch: expected \"\n| project TimeGenerated, Message",
              "size": 0,
              "title": "Elenco dei mismatch dei certificati",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Message",
                    "formatter": 0,
                    "formatOptions": {
                      "customColumnWidthSetting": "110ch"
                    }
                  }
                ]
              }
            },
            "name": "Elenco dei mismatch dei certificati"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "callback"
      },
      "name": "Callback"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Cancellazione",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"RTP cancellation sent to\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "✅ Cancellazioni totali con successo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "✅ Cancellazioni totali con successo",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancel RTP:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
              "size": 0,
              "title": "❌ Cancellazioni totali falliti",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "❌ Cancellazioni totali falliti",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s startswith '/rtp/rtps/'\n| where requestUri_s endswith '/cancel'\n| summarize count() by tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Cancellazioni RTP da APIM ( NO CODA ) ",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Cancellazioni RTP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| summarize\n    Successo   = countif(Message hasprefix \"RTP cancellation sent to\"),\n    Fallimento = countif(Message hasprefix \"Error cancel RTP:\")\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart",
              "size": 0,
              "title": "Cancellazioni nel tempo (Successi vs Fallimenti)",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
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
            "name": "Cancellazioni nel tempo (Successi vs Fallimenti)"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"RTP cancellation succeeded\" \n| summarize\n    [\"Cancellazioni con successo\"] = count()\n   by\n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Cancellazioni con successo\"] desc\n",
              "size": 0,
              "title": "✅ Cancellazioni con successo per Service Provider",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "unstackedbar",
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
            "name": "✅ Cancellazioni con successo per Service Provider"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Error cancel RTP\" \n| summarize\n    [\"Cancellazioni con fallimento\"] = count()\n   by\n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Cancellazioni con fallimento\"] desc",
              "size": 0,
              "title": "❌ Cancellazioni fallite per Service Provider",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "unstackedbar",
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
            "name": "❌ Cancellazioni fallite per Service Provider"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "cancellazione"
      },
      "name": "Cancellazione"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Service Providers",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppDependencies\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Data contains 'https://stgcbiglobeopenbankingapigateway.nexi.it/nexi/oauth/v2/token'\n| summarize count() by tostring(toint(ResultCode))\n\n",
              "size": 0,
              "title": "Status code chiamate verso endpoint di stacco token CBI",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "piechart",
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
            "name": "Status code chiamate verso endpoint di stacco token CBI"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "sp"
      },
      "name": "Service Providers"
    },
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
              "title": "Esito accessi a MongoDB, False = save già presenti nel DB.",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "piechart",
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
              "chartId": "workbookf5e29b43-e25f-479d-a569-88bb912d7f90",
              "version": "MetricsItem/2.0",
              "size": 0,
              "chartType": 2,
              "resourceType": "microsoft.documentdb/databaseaccounts",
              "metricScope": 0,
              "resourceIds": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
              ],
              "timeContext": {
                "durationMs": 2592000000
              },
              "metrics": [
                {
                  "namespace": "microsoft.documentdb/databaseaccounts",
                  "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                  "aggregation": 4,
                  "splitBy": null
                }
              ],
              "gridSettings": {
                "rowLimit": 10000
              }
            },
            "name": "metric - 1"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "activator"
      },
      "name": "Activator"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Disattivazioni",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s startswith \"/rtp/activation/activations/\"\n| where httpMethod_s == \"DELETE\"\n| where toint(httpStatus_d) == 204\n| summarize totalDeletes = count()\n| extend totalRequestsString = tostring(totalDeletes)\n",
              "size": 0,
              "title": "✅ Disattivazioni totali con successo",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Totale",
                    "formatter": 1
                  }
                ]
              },
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Disattivazioni totali con successo",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s startswith \"/rtp/activation/activations/\"\n| where httpMethod_s == \"DELETE\"\n| where toint(httpStatus_d) != 204\n| summarize totalDeletes = count()\n| extend totalRequestsString = tostring(totalDeletes)\n\n",
              "size": 0,
              "title": "❌ Disattivazioni totali fallite",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Disattivazioni totali",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/activation/activations\" and httpMethod_s == \"DELETE\"\n| summarize count() by tostring(toint(httpStatus_d))",
              "size": 0,
              "title": "Panoramica delle disattivazioni totali con status code",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "piechart",
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
            "customWidth": "50",
            "name": "Panoramica delle disattivazioni totali con status code",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s startswith \"/rtp/activation/activations/\"\n| where httpMethod_s == \"DELETE\"\n| where toint(httpStatus_d) in (401,400)\n| summarize totalDeletes = count()\n| extend totalRequestsString = tostring(totalDeletes)\n",
              "size": 0,
              "title": "❌ Disattivazioni fallite (APIM)",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Disattivazioni fallite (APIM)",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where AppRoleName == 'rtp-activator'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error deactivating payer\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)\n",
              "size": 0,
              "title": "❌ Disattivazioni fallite (Servizio)",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "stat",
              "statSettings": {
                "valueField": "totalRequestsString",
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
                "valueFontStyle": "auto"
              }
            },
            "customWidth": "25",
            "name": "Disattivazioni fallite (Servizio)",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Error deactivating payer\"\n| where Properties.LoggerName contains \"ActivationAPIControllerImpl\"\n| extend activation_id = tostring(Properties.activation_id)\n| summarize count_ = count() by activation_id\n| project-rename \n    [\"Activation ID\"] = activation_id, \n    [\"Count\"] = count_",
              "size": 0,
              "title": "❌ Disattivazioni fallite per Activation ID",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "table",
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
            "customWidth": "50",
            "name": "Disattivazioni fallite per Service Provider",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/activation/activations\"\n  and httpMethod_s == \"DELETE\"\n| summarize \n    Successo   = countif(httpStatus_d == 204),\n    Fallimento = countif(httpStatus_d != 204)\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
              "size": 0,
              "title": "Disattivazioni nel tempo (Successi vs Fallimenti) in bin di 1 ora",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ],
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
            "name": "Disattivazion nel tempo (Successi vs Fallimenti)"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"payer deactivated with id\"\n| extend service_provider = tostring(Properties.service_provider)\n| summarize count() by service_provider\n| project-rename \n    [\"Service Provider\"] = service_provider, \n    [\"Count\"] = count_",
              "size": 0,
              "title": "✅ Disattivazioni con successo per Service Provider",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
              ],
              "visualization": "categoricalbar",
              "tileSettings": {
                "showBorder": false,
                "titleContent": {
                  "columnMatch": "Service Provider",
                  "formatter": 1
                },
                "leftContent": {
                  "columnMatch": "Count",
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
                  "columnMatch": "TenantId",
                  "formatter": 1
                },
                "centerContent": {
                  "columnMatch": "SeverityLevel",
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
            "name": "✅ Disattivazioni con successo per Service Provider"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/activation/activations\" and httpMethod_s == \"DELETE\"\n| where serverStatus_s in (204)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc",
              "size": 0,
              "title": "✅ Status code dei successi delle disattivazioni per Client IP",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ]
            },
            "customWidth": "50",
            "name": "Status code dei successi delle disattivazioni per Client IP",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpStatus_d !in (204)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
              "size": 0,
              "title": "❌ Status code dei fallimenti delle disattivazioni per Client IP",
              "noDataMessageStyle": 3,
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
              ]
            },
            "customWidth": "50",
            "name": "Status code dei fallimenti delle disattivazioni per Client IP",
            "styleSettings": {
              "showBorder": true
            }
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "disattivazioni"
      },
      "name": "Disattivazioni"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "title": "Sender",
        "items": [
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "requests\n| where name contains \"GET /actuator/health\"\n| where timestamp {evaluation_window:query}\n| where cloud_RoleName == \"rtp-sender\"\n| summarize \n    [\"Numero di Richieste\"] = count(),\n    [\"Tempo Medio (ms)\"] = round(avg(duration), 3),\n    [\"Tempo Max (ms)\"] = round(max(duration), 3)\n  by [\"Endpoint\"] = name, [\"Result Code\"] = resultCode\n| order by [\"Numero di Richieste\"] desc\n",
              "size": 0,
              "title": "Comportamento probe readiness, liveness, startup. (Tutte sono esposte sullo stesso endpoint)",
              "exportParameterName": "Operation",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-${domain}-appinsights"
              ],
              "gridSettings": {
                "formatters": [
                  {
                    "columnMatch": "Mean|Median|p80|p95|p99",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": null,
                      "palette": "red"
                    }
                  },
                  {
                    "columnMatch": "Count",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": null,
                      "palette": "blue"
                    }
                  },
                  {
                    "columnMatch": "Users",
                    "formatter": 8,
                    "formatOptions": {
                      "min": 0,
                      "max": null,
                      "palette": "blueDark"
                    }
                  }
                ]
              }
            },
            "name": "query - 2"
          }
        ]
      },
      "conditionalVisibility": {
        "parameterName": "tab",
        "comparison": "isEqualTo",
        "value": "sender"
      },
      "name": "Sender Probe"
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
