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
}
