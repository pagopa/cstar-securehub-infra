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
}
