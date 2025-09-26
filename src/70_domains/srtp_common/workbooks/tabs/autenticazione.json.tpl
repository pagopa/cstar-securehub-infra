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
}