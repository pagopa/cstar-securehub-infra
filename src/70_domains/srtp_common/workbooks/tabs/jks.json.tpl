{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "JKS",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "traces\n| where timestamp {evaluation_window:query}\n| where customDimensions.LoggerName contains \"SendRtpProcessorImpl\"\n| where message contains \"trustAnchors parameter must be non-empty\"\n\n",
          "size": 0,
          "title": "JKS utilizzato risulta vuoto o con qualche problema",
          "queryType": 0,
          "resourceType": "microsoft.insights/components",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-${domain}-appinsights"
          ]
        },
        "name": "JKS utilizzato risulta vuoto o con qualche problema"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "traces\n| where timestamp {evaluation_window:query}\n| where customDimensions.LoggerName contains \"SendRtpProcessorImpl\"\n| where message contains \"unable to find valid certification path to requested\"",
          "size": 0,
          "title": "Mancanza della CA specifica per un determinato client",
          "timeContext": {
            "durationMs": 172800000
          },
          "queryType": 0,
          "resourceType": "microsoft.insights/components",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-${domain}-appinsights"
          ]
        },
        "name": "Mancanza della CA specifica per un determinato client"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "traces\n| where timestamp {evaluation_window:query}\n| where customDimensions.LoggerName contains \"SendRtpProcessorImpl\"\n| where message contains \"JKS file not found at path: /mnt/jks/trust_store.jks\"",
          "size": 0,
          "title": "JKS non presente",
          "timeContext": {
            "durationMs": 86400000
          },
          "queryType": 0,
          "resourceType": "microsoft.insights/components",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.Insights/components/${prefix}-${env_short}-${location_short}-${domain}-appinsights"
          ]
        },
        "name": "JKS non presente"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "jks"
  },
  "name": "JKS"
}