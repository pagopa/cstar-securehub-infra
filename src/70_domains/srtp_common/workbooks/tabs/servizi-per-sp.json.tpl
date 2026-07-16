{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Servizi per i SP",
    "items": [
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where httpMethod_s == \"GET\"\n| where requestUri_s contains 'rtp/activation/activations/payer'\n| where requestUri_s contains '/status'\n| summarize Count = count() by StatusCode = tostring(toint(httpStatus_d))\n| render piechart\n",
          "size": 0,
          "title": "Panoramica degli accessi totali alla getByFiscalCode con status code",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ]
        },
        "customWidth": "50",
        "name": "query - 0",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "let deps =\n    AppDependencies\n    | where TimeGenerated {evaluation_window:query}\n    | where Name startswith \"GET\" and Name contains \"/rtpactivator/activations/payer\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | where isnotempty(JWT_Subject)\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name contains \"activations/payer\" and Name contains \"/status\"\n| where ResultCode != \"200\"\n| project OperationId, ResultCode\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Label = strcat(JWT_Subject, \" (\", ResultCode, \")\")\n| summarize NumeroEventi = count() by Label\n| extend Label = strcat(Label, \" — \", NumeroEventi)\n| project Label, NumeroEventi\n",
          "size": 0,
          "title": "Accessi per Subject alla getByFiscalCode",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ]
        },
        "customWidth": "50",
        "name": "query - 1",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "let validOps = \n    AppDependencies\n    | where TimeGenerated {evaluation_window:query}\n    | where Name startswith \"GET\" and Name contains \"/rtpactivator/activations/payer\"\n    | distinct OperationId;\n\nlet deps =\n    AppDependencies\n    | where TimeGenerated {evaluation_window:query}\n    | where Name startswith \"GET\" and Name contains \"/rtpactivator/activations/payer\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name contains \"activations/payer\" and Name contains \"/status\"\n| join kind=inner validOps on OperationId\n| project OperationId, TimeGenerated, ResultCode\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Serie = strcat(JWT_Subject, \" - \", ResultCode)\n| render timechart with (series=Serie, title=\"Get Activation by Fiscal Code nel tempo\")\n",
          "size": 0,
          "title": "Accessi alla getByFiscalCode (Successi vs Fallimenti) in bin 1 ora",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ]
        },
        "name": "query - 2"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "SPServices"
  },
  "name": "group - 12"
}
