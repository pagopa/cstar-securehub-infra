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
          "query": "AppMetrics\n| where TimeGenerated {evaluation_window:query}\n| where Name startswith \"keycloak_user\"\n| extend\n    realm     = tostring(Properties[\"realm\"]),\n    client_id = tostring(Properties[\"client_id\"]),\n    event     = tostring(Properties[\"event\"]),\n    error     = tostring(Properties[\"error\"])\n| where realm == \"srtp\"\n| summarize\n    ['Token emessi']     = sum(ItemCount),\n    ['Ultima emissione'] = max(TimeGenerated),\n    ['Prima emissione']  = min(TimeGenerated)\n    by client_id, event, error\n| extend\n    ['Ultima emissione'] = format_datetime(['Ultima emissione'], \"yyyy-MM-dd HH:mm:ss\"),\n    ['Prima emissione']  = format_datetime(['Prima emissione'],  \"yyyy-MM-dd HH:mm:ss\")\n| order by ['Token emessi'] desc\n| project\n    ['Client ID']    = client_id,\n    ['Evento']       = event,\n    ['Errore']       = iff(error == \"\", \"-\", error),\n    ['Token emessi'],\n    ['Prima emissione'],\n    ['Ultima emissione']\n",
          "size": 0,
          "title": "Panoramica stacco del token (Metriche Keycloak)",
          "timeContextFromParameter": "evaluation_window",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-core-law"
          ]
        },
        "name": "query - 1"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "ApiManagementGatewayLogs\n| where TimeGenerated {evaluation_window:query}\n| where ApiId == \"${prefix}-${env_short}-${location_short}-mcshared-auth\"\n| where isnotempty(TraceRecords)\n| mv-expand trace = parse_json(TraceRecords)\n| where trace.source == \"KeycloakTokenIssued\"\n| extend\n    client_id   = tostring(trace.metadata.client_id),\n    sub         = tostring(trace.metadata.sub),\n    duration_ms = TotalTime\n| summarize\n    ['Token emessi']      = count(),\n    ['Ultima emissione']  = max(TimeGenerated),\n    ['Prima emissione']   = min(TimeGenerated),\n    ['Latenza media (ms)'] = round(avg(duration_ms), 0)\n    by client_id, sub\n| extend\n    ['Ultima emissione'] = format_datetime(['Ultima emissione'], \"yyyy-MM-dd HH:mm:ss\"),\n    ['Prima emissione']  = format_datetime(['Prima emissione'],  \"yyyy-MM-dd HH:mm:ss\")\n| order by ['Token emessi'] desc\n| project\n    ['Client ID']          = client_id,\n    ['Soggetto (sub)']     = sub,\n    ['Token emessi'],\n    ['Latenza media (ms)'],\n    ['Prima emissione'],\n    ['Ultima emissione']\n",
          "size": 0,
          "title": "Panoramica stacco del token (Keycloak)",
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
