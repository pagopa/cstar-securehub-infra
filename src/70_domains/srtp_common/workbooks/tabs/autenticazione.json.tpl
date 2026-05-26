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
