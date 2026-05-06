{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Get Enti",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/payees/consents'\n| summarize Count = count() by StatusCode = tostring(toint(httpStatus_d))\n| render piechart\n",
          "size": 0,
          "title": "Panoramica degli accessi totali al Payees Consents con status code",
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
        "name": "Panoramica degli accessi totali al Payees Consents con status code",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "let deps =\n    AppDependencies\n    | where TimeGenerated {evaluation_window:query}\n    | where Name startswith \"GET\" and Name contains \"/rtppayees\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | where isnotempty(JWT_Subject)\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-payees\"\n| where Name == \"GET /\"\n| where ResultCode != \"200\"\n| project OperationId, ResultCode\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Label = strcat(JWT_Subject, \" (\", ResultCode, \")\")\n| summarize NumeroEventi = count() by Label\n| extend Label = strcat(Label, \" — \", NumeroEventi)\n| project Label, NumeroEventi",
          "size": 0,
          "title": "✅ Accessi per Subject alla get payees",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ]
        },
        "customWidth": "50",
        "name": "✅ Accessi per Subject alla get payees",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/payees/consents'\n| summarize \n    Successo   = countif(httpStatus_d == 200),\n    Fallimento = countif(httpStatus_d != 200)\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
          "size": 0,
          "title": "Accessi al Payees Consents (Successi vs Fallimenti) in bin 1 ora",
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
        "name": "Accessi al Payees Consents (Successi vs Fallimenti) in bin 1 ora"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "getPayees"
  },
  "name": "Get Enti"
}
