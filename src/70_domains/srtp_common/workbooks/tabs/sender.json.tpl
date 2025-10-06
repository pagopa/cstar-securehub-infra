{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Sender",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "requests\n| where name contains \"GET /actuator/health\"\n| where timestamp {evaluation_window:query}\n| where cloud_RoleName == \"rtp-sender\"\n| summarize \n    [\"Numero di Richieste\"] = count(),\n    [\"Tempo Medio (ms)\"] = round(avg(duration), 3),\n    [\"Tempo Max (ms)\"] = round(max(duration), 3)\n  by [\"Endpoint\"] = name, [\"Result Code\"] = resultCode\n| order by [\"Numero di Richieste\"] desc\n",
          "size": 0,
          "title": "Comportamento probe readiness, liveness, startup. (Tutte sono esposte sullo stesso endpoint)",
          "exportParameterName": "Operation",
          "queryType": 0,
          "resourceType": "microsoft.insights/components",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-${domain}-appinsights"
          ],
          "gridSettings": {
            "formatters": [
              {
                "columnMatch": "Mean|Median|p80|p95|p99",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "max": null,
                  "palette": "red"
                }
              },
              {
                "columnMatch": "Count",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "max": null,
                  "palette": "blue"
                }
              },
              {
                "columnMatch": "Users",
                "formatter": 8,
                "formatOptions": {
                  "min": 0,
                  "max": null,
                  "palette": "blueDark"
                }
              }
            ]
          }
        },
        "name": "query - 2"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "sender"
  },
  "name": "Sender Probe"
}
