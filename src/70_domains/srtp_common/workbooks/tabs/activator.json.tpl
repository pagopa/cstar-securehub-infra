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
              "aggregation": 4
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
}
