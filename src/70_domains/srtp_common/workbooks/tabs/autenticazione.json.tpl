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
          "title": "Panoramica stacco del token (MIL)",
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
        "name": "Panoramica stacco del token (MIL)"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "ApiManagementGatewayLogs\n| where TimeGenerated {evaluation_window:query}\n| where OperationId == \"getKeycloakAccessTokens\"\n\n//| mv-expand TraceRecords\n//| where TraceRecords.metadata.key == \"counterKey\"\n//| summarize count=count() by client_id=tostring(TraceRecords.message), ResponseCode\n//| sort by client_id asc, ResponseCode asc",
          "size": 0,
          "title": "Panoramica stacco del token (Keycloak)",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
            "/subscriptions/${subscription_id}/resourceGroups/defaultresourcegroup-weu/providers/microsoft.operationalinsights/workspaces/defaultworkspace-${subscription_id}-weu",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-core-law",
            "/subscriptions/${subscription_id}/resourceGroups/cstar-d-itn-platform-synthetic-rg/providers/Microsoft.OperationalInsights/workspaces/cstar-d-itn-platform-synthetic-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-platform-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/cstar-d-itn-platform-monitoring-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-mdc-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-mdc-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-mcshared-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-mcshared-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-idpay-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-idpay-law"
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
        "name": "Panoramica stacco del token (Keycloak)"
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
