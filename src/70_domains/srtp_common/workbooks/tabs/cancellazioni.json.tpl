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
}
