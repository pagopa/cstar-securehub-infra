{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Invii SRTP (API)",
    "items": [
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
        "customWidth": "25",
        "name": "Panoramica degli invii totali con status code",
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
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "inviiAPI"
  },
  "name": "Invii SRTP (API)"
}
