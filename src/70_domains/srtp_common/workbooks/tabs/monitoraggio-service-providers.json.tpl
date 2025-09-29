{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Service Providers",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppDependencies\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Data contains 'https://stgcbiglobeopenbankingapigateway.nexi.it/nexi/oauth/v2/token'\n| summarize count() by tostring(toint(ResultCode))\n\n",
          "size": 0,
          "title": "Status code chiamate verso endpoint di stacco token CBI",
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
        "name": "Status code chiamate verso endpoint di stacco token CBI"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "sp"
  },
  "name": "Service Providers"
}
