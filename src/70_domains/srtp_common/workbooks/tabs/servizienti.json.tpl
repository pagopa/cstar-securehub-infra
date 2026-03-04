{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "let data = AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Name has \"GET\" and Name contains \"delivery-status\"\n| summarize count() by StatusCode = ResultCode;\ndata\n| union (\n    data\n    | where StatusCode !in (\"200\")\n    | summarize count_ = sum(count_)\n    | extend StatusCode = \"Total Errors\"\n)\n| order by count_ desc\n| render piechart",
          "size": 0,
          "title": "Panoramica delle richieste delivery-status con status code",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ],
          "visualization": "piechart",
          "chartSettings": {
            "showLegend": true,
            "seriesLabelSettings": [
              {
                "seriesName": "200",
                "label": "200 - OK",
                "color": "green"
              },
              {
                "seriesName": "400",
                "label": "400 - Bad Request",
                "color": "redBright"
              },
              {
                "seriesName": "401",
                "label": "401 - Unauthorized",
                "color": "orange"
              },
              {
                "seriesName": "500",
                "label": "500 - Server Error",
                "color": "red"
              },
              {
                "seriesName": "Total Errors",
                "label": "Totale Errori",
                "color": "redDark"
              }
            ]
          }
        },
        "customWidth": "50",
        "name": "Panoramica delivery-status",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Name has \"GET\" and Name contains \"delivery-status\"\n| extend Esito = iif(ResultCode == \"200\", \"✅ Successo\", \"❌ Fallimento\")\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Esito\n| render timechart with (series=Esito)",
          "size": 0,
          "title": "Richieste delivery-status nel tempo (Successi vs Fallimenti) in bin di 1 ora",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
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
        "customWidth": "50",
        "name": "delivery-status nel tempo (Successi vs Fallimenti)",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Name has \"GET\" and Name contains \"delivery-status\"\n| where ResultCode != \"200\"\n| project OperationId, TimeGenerated, ResultCode, Url\n| join kind=leftouter (\n    AppExceptions\n    | where AppRoleName == \"rtp-sender\"\n    | project OperationId, InnermostMessage\n) on OperationId\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| summarize Conteggio = count() by [\"Status Code\"] = ResultCode, [\"Motivo\"] = Motivo, [\"URL\"] = Url\n| order by Conteggio desc",
          "size": 0,
          "title": "❌ Richieste delivery-status fallite per Status Code e Motivo",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ],
          "visualization": "table"
        },
        "name": "Richieste delivery-status fallite per Status Code e Motivo",
        "styleSettings": {
          "showBorder": true
        }
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "servizienti"
  },
  "name": "Servizi per gli Enti"
}
