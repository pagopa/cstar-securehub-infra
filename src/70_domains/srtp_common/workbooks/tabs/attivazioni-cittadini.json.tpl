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
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppTraces\n| where AppRoleName == \"rtp-activator\"\n| where TimeGenerated {evaluation_window:query}\n| where Message hasprefix \"Error during activation process Authenticated user doesn't have permission to perform this action\"\n| extend tokenSpId = extract(@\"tokenSpId:\\s*([^\\s]+)\", 1, Message),\n         serviceProvider = extract(@\"service_provider=\"\"([^\"\"]+)\"\"\", 1, Message)\n| where isnotempty(tokenSpId) and isnotempty(serviceProvider)\n| summarize ['Error Count'] = count(), ['Service Providers'] = make_set(serviceProvider, 100)\n    by ['Token SP ID'] = tostring(tokenSpId)\n| order by ['Error Count'] desc\n",
          "size": 0,
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ]
        },
        "name": "query - 8"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "attivazioni"
  },
  "name": "Attivazioni"
}