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
}