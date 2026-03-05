{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "items": [
      {
        "type": 11,
        "content": {
          "version": "LinkItem/1.0",
          "style": "tabs",
          "links": [
            {
              "id": "a8e7460a-1bd2-44cf-aa60-1c476bb16c36",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Attivazione Cittadini",
              "subTarget": "rtp-activator-activations",
              "style": "link"
            },
            {
              "id": "a135d099-bd65-47b0-b06b-b9e67037c7d9",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Disattivazione Cittadini",
              "subTarget": "rtp-activator-deactivations",
              "style": "link"
            },
            {
              "id": "4166613d-5ad2-464b-b8ff-83518c77f5b9",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Subentri Cittadini",
              "subTarget": "rtp-activator-takeovers",
              "style": "link"
            },
            {
              "id": "507471d4-2318-4855-ba92-0e6b3dca48a0",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Cosmos Activator",
              "subTarget": "rtp-activator-db",
              "style": "link"
            }
          ]
        },
        "name": "links - 0 - Copy"
      },
      {
        "type": 9,
        "content": {
          "version": "KqlParameterItem/1.0",
          "parameters": [
            {
              "id": "88e0963f-5b6e-4a17-a312-8af7f9c2a6b6",
              "version": "KqlParameterItem/1.0",
              "name": "SubjectParam",
              "label": "Seleziona Service Provider",
              "type": 2,
              "isRequired": true,
              "multiSelect": true,
              "quote": "'",
              "delimiter": ",",
              "typeSettings": {
                "additionalResourceOptions": [
                  "value::all"
                ],
                "showDefault": false
              },
              "jsonData": "[\n    { \"value\": \"UNCRITMM\", \"label\": \"Unicredit\" },\n    { \"value\": \"ICRAITRRXXX\", \"label\": \"ICCREA\" },\n    { \"value\": \"BNCMITRR\", \"label\": \"Bancomat\" },\n    { \"value\": \"PPAYITR1XXX\", \"label\": \"Poste\" },\n    { \"value\": \"HYEEIT22XXX\", \"label\": \"Hype\" },\n    { \"value\": \"UNKNOWN\", \"label\": \"UNKNOWN\" },\n    { \"value\": \"FAKESP01\", \"label\": \"FAKESP01\" },\n    { \"value\": \"MOCKSP01\", \"label\": \"MOCKSP01\" },\n    { \"value\": \"MOCKSP04\", \"label\": \"MOCKSP04\" },\n    { \"value\": \"TAKEOV01\", \"label\": \"TAKEOV01\" },  \n { \"value\": \"FAKESP02\", \"label\": \"FAKESP02\" },  \n { \"value\": \"00348170101\", \"label\": \"00348170101\" }, \n { \"value\": \"984500A9EB6B07AC2G71\", \"label\": \"984500A9EB6B07AC2G71\" }]",
              "timeContext": {
                "durationMs": 86400000
              },
              "defaultValue": "value::all",
              "value": [
                "value::all"
              ]
            }
          ],
          "style": "pills",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces"
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isNotEqualTo",
          "value": "rtp-activator-db"
        },
        "name": "parameters - service-provider"
      },
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
                "query": "let data = AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| summarize count() by StatusCode = ResultCode;\ndata\n| union (\n    data\n    | where StatusCode !in (\"201\", \"409\")\n    | summarize count_ = sum(count_)\n    | extend StatusCode = \"Total Errors\"\n)\n| order by count_ desc\n| render piechart",
                "size": 0,
                "title": "Panoramica delle attivazioni totali con status code",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "createOtherGroup": 20,
                  "showLegend": true,
                  "seriesLabelSettings": [
                    {
                      "seriesName": "201",
                      "label": "201 - Creato",
                      "color": "green"
                    },
                    {
                      "seriesName": "409",
                      "label": "409 - Duplicato",
                      "color": "orange"
                    },
                    {
                      "seriesName": "400",
                      "label": "400 - Bad Request",
                      "color": "redBright"
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
                  ],
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
              "name": "Panoramica attivazioni",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppDependencies\n| where Name == \"POST /rtpactivator/activations\"\n| where Success == false\n| extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend RC = trim(\" \", tostring(ResultCode))\n| extend RC = iif(isempty(RC) or RC == \"0\", \"500\", RC)\n| extend Label = strcat(JWT_Subject, \" (\", RC, \")\")\n| summarize NumeroEventi = count() by Label",
                "size": 0,
                "title": "❌ Distribuzione Errori per Subject e Status Code",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "createOtherGroup": 100,
                  "showMetrics": false,
                  "showLegend": true
                }
              },
              "customWidth": "50",
              "name": "Distribuzione Errori per Subject e Status Code",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let deps =\n    AppDependencies\n    | where Name startswith \"POST\" and Name contains \"/rtpactivator/activations\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n \nlet ex =\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | summarize InnermostMessage = any(InnermostMessage) by OperationId;\n \nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| where ResultCode == \"400\"\n| project OperationId, TimeGenerated, Name\n| join kind=leftouter deps on OperationId\n| join kind=leftouter ex on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count() by [\"Service Provider\"]=JWT_Subject, Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Distribuzione Errori 400 per Subject",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Distribuzione Errori 400 per Subject",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let deps =\n    AppDependencies\n    | where Name startswith \"POST\" and Name contains \"/rtpactivator/activations\"\n    | where Success == false\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nlet ex =\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | summarize InnermostMessage = any(InnermostMessage) by OperationId;\n\nlet tr =\n    AppTraces\n    | where AppRoleName == \"rtp-activator\"\n    | summarize HasTrace = any(true) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| where ResultCode != \"201\" and ResultCode != \"409\" and ResultCode != \"400\"\n| project OperationId, TimeGenerated, Name, ResultCode\n| join kind=leftouter deps on OperationId\n| join kind=leftouter ex on OperationId\n| join kind=leftouter tr on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count()\n    by [\"Service Provider\"] = JWT_Subject,\n       [\"Status Code\"] = ResultCode,\n       Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Distribuzione Altri Errori (esclusi 400) per Service Provider",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Distribuzione Tutti gli Errori per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let deps =\n    AppDependencies\n    | where Name startswith \"POST\" and Name contains \"/rtpactivator/activations\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| where ResultCode != \"409\"\n| project OperationId, TimeGenerated, ResultCode\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend Esito = iif(ResultCode == \"201\", \"✅ Successo\", \"❌ Fallimento\")\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Serie = strcat(JWT_Subject, \" - \", Esito)\n| render timechart with (series=Serie, title=\"Attivazioni nel tempo\")",
                "size": 0,
                "title": "Attivazioni nel tempo (Successi vs Fallimenti) in bin 1 ora",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
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
              "name": "Attivazioni nel tempo (Successi vs Fallimenti)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let deps =\n    AppDependencies\n    | where Name startswith \"POST\" and Name contains \"/rtpactivator/activations\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| where ResultCode == \"201\"\n| project OperationId\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| summarize Count = count() by [\"Service Provider\"] = JWT_Subject\n| order by Count desc",
                "size": 0,
                "aggregation": 5,
                "title": "✅ Attivazioni con successo per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "unstackedbar",
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
              "name": "Attivazioni con successo per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let deps =\n    AppDependencies\n    | where Name startswith \"POST\" and Name contains \"/rtpactivator/activations\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | summarize JWT_Subject = any(JWT_Subject) by OperationId;\n\nAppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"activations\"\n| where ResultCode != \"201\" and ResultCode != \"409\"\n| project OperationId\n| join kind=leftouter deps on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| summarize Count = count() by [\"Service Provider\"] = JWT_Subject\n| order by Count desc",
                "size": 0,
                "aggregation": 5,
                "title": "❌ Attivazioni fallite per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "unstackedbar",
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
              "name": "Attivazioni fallite per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-activator\"\n| where TimeGenerated {evaluation_window:query}\n| where Message hasprefix \"Error during activation process Authenticated user doesn't have permission to perform this action\"\n| extend tokenSpId = extract(@\"tokenSpId:\\s*([^\\s]+)\", 1, Message)\n| extend props = todynamic(Properties)\n| extend serviceProvider = tostring(props[\"service_provider\"])\n| where isnotempty(tokenSpId) and isnotempty(serviceProvider)\n| summarize\n    ['Error Count'] = count(),\n    ['Service Providers'] = make_set(serviceProvider, 100)\n  by ['Token SP ID'] = tostring(tokenSpId)\n| order by ['Error Count'] desc\n",
                "size": 1,
                "title": "❌ Mismatch del Service Provider tra Token e Body",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "Mismatch del SP tra token e body",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpStatus_d !in (200, 201)\n| extend geo = geo_info_from_ip_address(clientIP_s)\n| extend Latitudine = toreal(geo.latitude), Longitudine = toreal(geo.longitude), Paese = tostring(geo.country)\n| summarize [\"Conteggio\"] = count() by [\"Client IP\"] = clientIP_s, [\"Http Status Code\"] = tostring(toint(httpStatus_d)), Latitudine, Longitudine, Paese\n| order by [\"Conteggio\"] desc",
                "size": 0,
                "title": "❌ Status code dei fallimenti delle attivazioni per Client IP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Status code dei fallimenti delle attivazioni",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/activation/activations'\n| where httpStatus_d in (200, 201)\n| extend geo = geo_info_from_ip_address(clientIP_s)\n| extend Latitudine = toreal(geo.latitude), Longitudine = toreal(geo.longitude), Paese = tostring(geo.country)\n| summarize [\"Conteggio\"] = count() by [\"Client IP\"] = clientIP_s, Latitudine, Longitudine, Paese\n| order by [\"Conteggio\"] desc",
                "size": 0,
                "title": "✅ Status code dei successi delle attivazioni per Client IP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Status code dei successi delle attivazioni",
              "styleSettings": {
                "showBorder": true
              }
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "rtp-activator-activations"
        },
        "name": "Attivazioni"
      },
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
                "query": "let data = AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"takeover\"\n| summarize count() by StatusCode = ResultCode;\ndata\n| union (\n    data\n    | where StatusCode !in (\"201\", \"409\")\n    | summarize count_ = sum(count_)\n    | extend StatusCode = \"Total Errors\"\n)\n| order by count_ desc\n| render piechart",
                "size": 0,
                "title": "Panoramica degli status code per il Subentro",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "showLegend": true,
                  "seriesLabelSettings": [
                    {
                      "seriesName": "201",
                      "label": "201 - Subentro OK",
                      "color": "green"
                    },
                    {
                      "seriesName": "409",
                      "label": "409 - Conflitto",
                      "color": "orange"
                    },
                    {
                      "seriesName": "400",
                      "label": "400 - Bad Request",
                      "color": "redBright"
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
                  ],
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
              "name": "Panoramica subentri",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppDependencies\n| where Name has \"POST /rtpactivator/activations/takeover\"\n| where Success == false\n| extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend RC = trim(\" \", tostring(ResultCode))\n| extend RC = iif(isempty(RC) or RC == \"0\", \"500\", RC)\n| extend Label = strcat(JWT_Subject, \" (\", RC, \")\")\n| summarize NumeroEventi = count() by Label",
                "size": 0,
                "title": "❌ Distribuzione Errori per Subject e Status Code",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "createOtherGroup": 100,
                  "showMetrics": false,
                  "showLegend": true
                }
              },
              "customWidth": "50",
              "name": "Distribuzione Errori per Subject e Status Code",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let data = AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Payer already exists, generating takeover OTP\"\n    or Message startswith \"OTP expired due to expiration time exceeded\"\n    or Message startswith \"Request rejected due to nonexistent OTP\"\n| extend Motivo = case(\n    Message startswith \"Payer already exists, generating takeover OTP\", \"OTP Generato\",\n    Message startswith \"OTP expired due to expiration time exceeded\", \"OTP Scaduto\",\n    Message startswith \"Request rejected due to nonexistent OTP\", \"OTP Inesistente\",\n    \"Altro\"\n)\n| summarize Conteggio = count() by Motivo;\ndatatable(Motivo:string, Conteggio:long) [\n    \"OTP Generato\", 0,\n    \"OTP Scaduto\", 0,\n    \"OTP Inesistente\", 0\n]\n| union data\n| summarize Conteggio = sum(Conteggio) by Motivo\n| render piechart",
                "size": 0,
                "title": "Monitoraggio degli OTP generati",
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
                      "seriesName": "OTP Generato",
                      "color": "green"
                    },
                    {
                      "seriesName": "OTP Scaduto",
                      "color": "orange"
                    },
                    {
                      "seriesName": "OTP Inesistente",
                      "color": "redBright"
                    }
                  ]
                }
              },
              "customWidth": "50",
              "name": "Monitoraggio OTP",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"takeover\"\n| where ResultCode != \"201\" and ResultCode != \"409\"\n| project OperationId, TimeGenerated, Name, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"takeover\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | extend activation_id = extract(@\"activations/([^/]+)/takeover\", 1, Name)\n    | project OperationId, JWT_Subject, activation_id\n) on OperationId\n| join kind=leftouter (\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | project OperationId, InnermostMessage\n) on OperationId\n| join kind=leftouter (\n    AppTraces\n    | where AppRoleName == \"rtp-activator\"\n    | extend activation_id = tostring(Properties.activation_id)\n    | where isnotempty(activation_id)\n    | project OperationId, activation_id\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend activation_id = coalesce(activation_id, activation_id1, \"N/A\")\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count() by [\"Activation ID\"] = activation_id, [\"Service Provider\"] = JWT_Subject, [\"Status Code\"] = ResultCode, Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Subentri falliti per Activation ID",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Subentri falliti per Activation ID",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"takeover\"\n| where ResultCode != \"201\" and ResultCode != \"409\" and ResultCode != \"400\"\n| project OperationId, TimeGenerated, Name, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"takeover\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| join kind=leftouter (\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | project OperationId, InnermostMessage\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count() by [\"Service Provider\"] = JWT_Subject, [\"Status Code\"] = ResultCode, Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Distribuzione Altri Errori (esclusi 400) per Service Provider",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Distribuzione Tutti gli Errori per Service Provider - Takeover",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name startswith \"POST\" and Name contains \"takeover\"\n| project OperationId, TimeGenerated, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"takeover\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend Esito = iif(ResultCode == \"201\", \"✅ Successo\", \"❌ Fallimento\")\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Serie = strcat(JWT_Subject, \" - \", Esito)\n| render timechart with (series=Serie)",
                "size": 0,
                "title": "Subentri nel tempo (Successi vs Fallimenti) in bin 1 ora",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
              "name": "Subentri nel tempo (Successi vs Fallimenti)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Error retrieving takeover URI for service provider id:\"\n| extend service_provider_id = extract(\"service provider id: ([^\\\\s]+)\", 1, Message)\n| summarize count_ = count() by service_provider_id\n| project-rename \n    [\"Service Provider ID\"] = service_provider_id,\n    [\"Count\"] = count_\n",
                "size": 0,
                "title": "❌ Accessi falliti al Service Registry per recupero SP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Accessi falliti al Service Registry",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Successfully retrieved technical service provider for service provider id:\"\n| extend service_provider_id = extract(\"service provider id: ([^\\\\s]+)\", 1, Message)\n| summarize count_ = count() by service_provider_id\n| project-rename \n    [\"Service Provider ID\"] = service_provider_id,\n    [\"Count\"] = count_\n",
                "size": 0,
                "title": "✅ Accessi con successo al Service Registry per recupero SP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Accessi con successo al Service Registry",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Sending takeover notification\"\n| extend service_provider_id = extract(\"Service Provider: ([^\\\\.]+)\", 1, Message)\n| summarize count_ = count() by service_provider_id\n| project-rename \n    [\"Service Provider ID\"] = service_provider_id,\n    [\"Takeover Notifications Sent\"] = count_\n",
                "size": 0,
                "title": "📤 Tentativi di invio notifica per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "33",
              "name": "Tentativi invio notifica",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Takeover notification process completed for Service Provider\"\n| extend service_provider_id = extract(\"Service Provider: ([^\\\\.]+)\", 1, Message)\n| summarize count_ = count() by service_provider_id\n| project-rename \n    [\"Service Provider ID\"] = service_provider_id,\n    [\"Takeover Notifications Sent\"] = count_\n",
                "size": 0,
                "title": "✅ Invio notifica con successo per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "33",
              "name": "Invio notifica con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Takeover notification process failed\"\n| extend service_provider_id = extract(\"Service Provider: ([^\\\\.]+)\", 1, Message)\n| summarize count_ = count() by service_provider_id\n| project-rename \n    [\"Service Provider ID\"] = service_provider_id,\n    [\"Takeover Notifications Failed\"] = count_\n",
                "size": 0,
                "title": "❌ Invio notifica fallito per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "33",
              "name": "Invio notifica fallito",
              "styleSettings": {
                "showBorder": true
              }
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "rtp-activator-takeovers"
        },
        "name": "Takeover"
      },
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
                "query": "let data = AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| summarize count() by StatusCode = ResultCode;\ndata\n| union (\n    data\n    | where StatusCode !in (\"204\", \"409\")\n    | summarize count_ = sum(count_)\n    | extend StatusCode = \"Total Errors\"\n)\n| order by count_ desc\n| render piechart",
                "size": 0,
                "title": "Panoramica delle disattivazioni totali con status code",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "showLegend": true,
                  "seriesLabelSettings": [
                    {
                      "seriesName": "204",
                      "label": "204 - Disattivato",
                      "color": "green"
                    },
                    {
                      "seriesName": "409",
                      "label": "409 - Conflitto",
                      "color": "orange"
                    },
                    {
                      "seriesName": "400",
                      "label": "400 - Bad Request",
                      "color": "redBright"
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
                  ],
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
              "name": "Panoramica disattivazioni",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppDependencies\n| where Name has \"DELETE /rtpactivator/activations/\"\n| where Success == false\n| extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend RC = trim(\" \", tostring(ResultCode))\n| extend RC = iif(isempty(RC) or RC == \"0\", \"500\", RC)\n| extend Label = strcat(JWT_Subject, \" (\", RC, \")\")\n| summarize NumeroEventi = count() by Label",
                "size": 0,
                "title": "❌ Distribuzione Errori per Subject e Status Code",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart",
                "chartSettings": {
                  "createOtherGroup": 100,
                  "showMetrics": false,
                  "showLegend": true
                }
              },
              "customWidth": "50",
              "name": "Distribuzione Errori per Subject e Status Code",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| where ResultCode != \"204\"\n| project OperationId, TimeGenerated, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"DELETE /rtpactivator/activations/\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | extend activation_id = extract(@\"activations/([^/]+)\", 1, Name)\n    | project OperationId, JWT_Subject, activation_id\n) on OperationId\n| join kind=leftouter (\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | project OperationId, InnermostMessage\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| extend activation_id = iif(isempty(activation_id), \"N/A\", activation_id)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count() by [\"Activation ID\"] = activation_id, [\"Service Provider\"] = JWT_Subject, [\"Status Code\"] = ResultCode, [\"Motivo\"] = Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Disattivazioni fallite per Activation ID",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Disattivazioni fallite per Activation ID",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| where ResultCode != \"204\" and ResultCode != \"400\"\n| project OperationId, TimeGenerated, Name, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"DELETE /rtpactivator/activations/\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| join kind=leftouter (\n    AppExceptions\n    | where AppRoleName == \"rtp-activator\"\n    | project OperationId, InnermostMessage\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| extend Motivo = iif(isempty(InnermostMessage), \"N/A\", InnermostMessage)\n| where JWT_Subject in ({SubjectParam})\n| summarize Conteggio = count() by [\"Service Provider\"] = JWT_Subject, [\"Status Code\"] = ResultCode, Motivo\n| order by Conteggio desc",
                "size": 0,
                "title": "❌ Distribuzione Altri Errori (esclusi 400) per Service Provider",
                "noDataMessageStyle": 3,
                "timeContextFromParameter": "evaluation_window",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Distribuzione Tutti gli Errori per Service Provider - Disattivazioni",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| project OperationId, TimeGenerated, ResultCode\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"DELETE /rtpactivator/activations/\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| extend Esito = iif(ResultCode == \"204\", \"✅ Successo\", \"❌ Fallimento\")\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Serie = strcat(JWT_Subject, \" - \", Esito)\n| render timechart with (series=Serie)",
                "size": 0,
                "title": "Disattivazioni nel tempo (Successi vs Fallimenti) in bin di 1 ora",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law",
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
              "name": "Disattivazioni nel tempo (Successi vs Fallimenti)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| where ResultCode == \"204\"\n| project OperationId\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"DELETE /rtpactivator/activations/\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| summarize [\"Conteggio\"] = count() by [\"Service Provider\"] = JWT_Subject",
                "size": 0,
                "title": "✅ Disattivazioni con successo per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "unstackedbar",
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
              "name": "Disattivazioni con successo per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppRequests\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Name has \"DELETE\" and Name contains \"activations\"\n| where ResultCode != \"204\"\n| project OperationId\n| join kind=leftouter (\n    AppDependencies\n    | where Name has \"DELETE /rtpactivator/activations/\"\n    | extend JWT_Subject = tostring(Properties[\"Request-X-JWT-Subject\"])\n    | project OperationId, JWT_Subject\n) on OperationId\n| extend JWT_Subject = iif(isempty(JWT_Subject), \"UNKNOWN\", JWT_Subject)\n| where JWT_Subject in ({SubjectParam})\n| summarize [\"Conteggio\"] = count() by [\"Service Provider\"] = JWT_Subject",
                "size": 0,
                "title": "❌ Disattivazioni fallite per Service Provider",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "unstackedbar",
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
              "name": "Disattivazioni fallite per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/activation/activations\" and httpMethod_s == \"DELETE\"\n| where serverStatus_s in (204)\n| extend geo = geo_info_from_ip_address(clientIP_s)\n| extend Latitudine = toreal(geo.latitude), Longitudine = toreal(geo.longitude), Paese = tostring(geo.country)\n| summarize [\"Conteggio\"] = count() by [\"Client IP\"] = clientIP_s, [\"Http Status Code\"] = tostring(toint(httpStatus_d)), Latitudine, Longitudine, Paese\n| order by [\"Conteggio\"] desc",
                "size": 0,
                "title": "✅ Status code dei successi delle disattivazioni per Client IP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Successi disattivazioni per Client IP",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/activation/activations\" and httpMethod_s == \"DELETE\"\n| where httpStatus_d != 204\n| extend geo = geo_info_from_ip_address(clientIP_s)\n| extend Latitudine = toreal(geo.latitude), Longitudine = toreal(geo.longitude), Paese = tostring(geo.country)\n| summarize [\"Conteggio\"] = count() by [\"Client IP\"] = clientIP_s, [\"Http Status Code\"] = tostring(toint(httpStatus_d)), Latitudine, Longitudine, Paese\n| order by [\"Conteggio\"] desc",
                "size": 0,
                "title": "❌ Status code dei fallimenti delle disattivazioni per Client IP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Fallimenti disattivazioni per Client IP",
              "styleSettings": {
                "showBorder": true
              }
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "rtp-activator-deactivations"
        },
        "name": "Disattivazioni"
      },
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
                "query": "let dati = AppDependencies\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Target == 'mongodb | activation'\n| summarize Conteggio = count() by Esito = case(tostring(Success) == 'True', '✅ Successo', '⚠️ Duplicato (già presente)');\nlet defaults = datatable(Esito:string, Conteggio:long)[\n    '✅ Successo', 0,\n    '⚠️ Duplicato (già presente)', 0\n];\ndefaults\n| where Esito !in ((dati | project Esito))\n| union dati\n| order by Esito asc",
                "size": 3,
                "title": "Esito Salvataggi su MongoDB (rtp-activator → activation)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "tiles",
                "tileSettings": {
                  "titleContent": {
                    "columnMatch": "Esito",
                    "formatter": 1
                  },
                  "leftContent": {
                    "columnMatch": "Conteggio",
                    "formatter": 12,
                    "formatOptions": {
                      "palette": "auto"
                    },
                    "numberFormat": {
                      "unit": 17,
                      "options": {
                        "style": "decimal",
                        "useGrouping": true,
                        "maximumFractionDigits": 0
                      }
                    }
                  },
                  "showBorder": true
                }
              },
              "name": "Esito accessi a MongoDB"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppDependencies\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Target == 'mongodb | activation'\n| extend Esito = case(tostring(Success) == 'True', '✅ Successo', '⚠️ Duplicato')\n| summarize Conteggio = count() by bin(TimeGenerated, 1h), Esito\n| order by TimeGenerated asc",
                "size": 0,
                "title": "Salvataggi su MongoDB nel Tempo - Successi vs Duplicati (rtp-activator → activation)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "timechart",
                "chartSettings": {
                  "seriesLabelSettings": [
                    {
                      "seriesName": "✅ Successo",
                      "color": "green"
                    },
                    {
                      "seriesName": "⚠️ Duplicato",
                      "color": "orange"
                    }
                  ]
                }
              },
              "name": "Salvataggi MongoDB nel Tempo"
            },
            {
              "type": 1,
              "content": {
                "json": "## 📊 Cosmos DB - Shared Throughput Analysis\n---\n**Come leggere questa griglia:**\n\n| Colonna | Cosa indica | Quando preoccuparsi |\n|---|---|---|\n| **Total RU Consumed** | Costo effettivo in Request Units per collection | Una collection consuma >80% del totale |\n| **Mongo Requests** | Numero di operazioni MongoDB | Rapporto requests/documenti molto alto (es. polling) |\n| **Document Count** | Numero di documenti nella collection | — |\n| **Data Usage / Index Usage** | Storage dati e indici | Data Usage sproporzionato rispetto al Document Count |\n| **Normalized RU %** | % di utilizzo del throughput condiviso (0-100%) | >70% = attenzione, >90% = throttling imminente |\n| **Autoscale Max Throughput** | RU massime configurate (a livello database) | Se Normalized RU è costantemente alto, aumentare questo valore |\n| **Throttled (429/16500)** | Richieste rifiutate per throughput insufficiente | Qualsiasi valore >0 indica un problema attivo |\n\n⚠️ **Nota:** Il throughput è **shared a livello database** — tutte le collection competono per le stesse RU. Se una collection domina il consumo, le altre possono subire throttling."
              },
              "name": "text - 5"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook9ee57fd6-b139-4730-ac8b-ae263ee8cb58",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 0,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                    "aggregation": 1,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10,
                    "columnName": "Total RU Consumed"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10,
                    "columnName": "Mongo Client Requests"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                    "aggregation": 3,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10,
                    "columnName": "Normalized RU % (Max)"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-AutoscaleMaxThroughput",
                    "aggregation": 3,
                    "splitBy": [
                      "DatabaseName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 10,
                    "columnName": "Throttled Requests (16500)",
                    "filters": [
                      {
                        "key": "ErrorCode",
                        "operator": 0,
                        "values": [
                          "16500"
                        ]
                      }
                    ]
                  }
                ],
                "title": "Cosmos DB - Shared Throughput Analysis (Database: activation)",
                "gridFormatType": 2,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "showExpandCollapseGrid": true,
                "gridSettings": {
                  "formatters": [
                    {
                      "columnMatch": "$gen_group",
                      "formatter": 13,
                      "formatOptions": {
                        "linkTarget": "Resource",
                        "showIcon": true
                      }
                    },
                    {
                      "columnMatch": "Subscription",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Name",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Segment",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Total RU Consumed",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "red",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 17,
                        "options": {
                          "style": "decimal",
                          "useGrouping": true,
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "Total RU Consumed Timeline",
                      "formatter": 9,
                      "formatOptions": {
                        "min": 0,
                        "palette": "red",
                        "aggregation": "Sum"
                      }
                    },
                    {
                      "columnMatch": "Mongo Client Requests",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "blue",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 17,
                        "options": {
                          "style": "decimal",
                          "useGrouping": true,
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "Mongo Client Requests Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "yellow",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 17,
                        "options": {
                          "style": "decimal",
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "green",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 2,
                        "options": {
                          "style": "decimal",
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-DataUsage Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "green",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 2,
                        "options": {
                          "style": "decimal",
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Normalized RU % (Max)",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "max": 100,
                        "palette": "redGreen",
                        "aggregation": "Max"
                      },
                      "numberFormat": {
                        "unit": 1,
                        "options": {
                          "style": "decimal",
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "Normalized RU % (Max) Timeline",
                      "formatter": 9,
                      "formatOptions": {
                        "min": 0,
                        "max": 100,
                        "palette": "redGreen",
                        "aggregation": "Max"
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-AutoscaleMaxThroughput",
                      "formatter": 1,
                      "numberFormat": {
                        "unit": 0,
                        "options": {
                          "style": "decimal",
                          "useGrouping": true
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-AutoscaleMaxThroughput Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Throttled Requests (16500)",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "redBright",
                        "aggregation": "Sum"
                      },
                      "numberFormat": {
                        "unit": 17,
                        "options": {
                          "style": "decimal",
                          "useGrouping": true,
                          "maximumFractionDigits": 0
                        }
                      }
                    },
                    {
                      "columnMatch": "Throttled Requests (16500) Timeline",
                      "formatter": 9,
                      "formatOptions": {
                        "min": 0,
                        "palette": "redBright",
                        "aggregation": "Sum"
                      }
                    }
                  ],
                  "rowLimit": 10000,
                  "filter": true,
                  "hierarchySettings": {
                    "treeType": 1,
                    "groupBy": [
                      "Name"
                    ],
                    "expandTopLevel": true,
                    "finalBy": "Segment"
                  },
                  "labelSettings": [
                    {
                      "columnId": "Subscription",
                      "label": "Subscription/Database/Collection"
                    },
                    {
                      "columnId": "Name",
                      "label": "Collections"
                    },
                    {
                      "columnId": "Segment",
                      "label": "Collection"
                    },
                    {
                      "columnId": "Total RU Consumed",
                      "label": "Total RU Consumed (Sum)"
                    },
                    {
                      "columnId": "Total RU Consumed Timeline",
                      "label": "RU Consumed Timeline"
                    },
                    {
                      "columnId": "Mongo Client Requests",
                      "label": "Mongo Requests (Count)"
                    },
                    {
                      "columnId": "Mongo Client Requests Timeline",
                      "label": "Mongo Requests Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                      "label": "Document Count (Avg)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount Timeline",
                      "label": "Document Count Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                      "label": "Data Usage (Avg)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage Timeline",
                      "label": "Data Usage Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                      "label": "Index Usage (Avg)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage Timeline",
                      "label": "Index Usage Timeline"
                    },
                    {
                      "columnId": "Normalized RU % (Max)",
                      "label": "Normalized RU % (Max)"
                    },
                    {
                      "columnId": "Normalized RU % (Max) Timeline",
                      "label": "Normalized RU % Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-AutoscaleMaxThroughput",
                      "label": "Autoscale Max Throughput (Max)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-AutoscaleMaxThroughput Timeline",
                      "label": "Autoscale Max Throughput Timeline"
                    },
                    {
                      "columnId": "Throttled Requests (16500)",
                      "label": "Throttled (429/16500)"
                    },
                    {
                      "columnId": "Throttled Requests (16500) Timeline",
                      "label": "Throttled Timeline"
                    }
                  ]
                },
                "sortBy": [],
                "showExportToExcel": true
              },
              "name": "Cosmos DB - Shared Throughput Analysis"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook859d09ea-f343-478c-a0a0-5eaf79f8ac34",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "timeGrain": "PT1H",
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                    "aggregation": 3,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "columnName": "Normalized RU % by Collection"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                    "aggregation": 1,
                    "columnName": "RU Consumed by Collection"
                  }
                ],
                "title": "Normalized RU Consumption & RU Cost by Collection (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "NormalizedRUConsumption by Collection"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbookaf172b5e-e51e-4ea3-a191-0de5841b33b6",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                    "aggregation": 1,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "columnName": "RU Consumed"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "columnName": "Throttled Requests",
                    "filters": [
                      {
                        "key": "ErrorCode",
                        "operator": 0,
                        "values": [
                          "16500"
                        ]
                      }
                    ]
                  }
                ],
                "title": "Total RU Consumed & Throttling by Collection (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Total RU by Collection"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook2a2620ac-8baa-40e1-98cf-4ebad54f82db",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-TotalRequestUnits",
                    "aggregation": 1,
                    "splitBy": [
                      "CollectionName",
                      "OperationType"
                    ],
                    "columnName": "RU by Collection & Operation"
                  }
                ],
                "title": "Total RU Cost by Collection & Operation Type (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "RU by Collection and Operation Type"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbookb53a712c-9e6d-424b-a727-0744595027dc",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "splitBy": [
                      "CollectionName",
                      "CommandName"
                    ],
                    "columnName": "Requests by Collection & Command"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "columnName": "Requests by Collection & Status"
                  }
                ],
                "title": "MongoDB Requests by Collection, Command & Error Code (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "MongoDB Requests by Collection and Command"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook70c7cafe-2575-4902-8651-b9ca636916bf",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "splitBy": [
                      "CollectionName",
                      "ErrorCode"
                    ],
                    "columnName": "Failed Requests by Collection & Error"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "columnName": "Failed Requests by Collection & Command"
                  }
                ],
                "title": "Failed Requests by Collection, Error Code & Command (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "3",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  },
                  {
                    "id": "4",
                    "key": "ErrorCode",
                    "operator": 1,
                    "values": [
                      "0"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Failed Requests by Collection and Error"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook9108a8f3-b930-46e6-a394-50417a940b87",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "columnName": "Data Usage"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                    "aggregation": 4,
                    "columnName": "Index Usage"
                  }
                ],
                "title": "Data & Index Usage by Collection (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Data and Index Usage by Collection"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbook7eaa1654-64ba-4205-9242-e0d2fb8f3078",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
                    "aggregation": 4,
                    "columnName": "Availability (Avg %)"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
                    "aggregation": 2,
                    "columnName": "Availability (Min %)"
                  }
                ],
                "title": "Service Availability - Min & Avg % (Account Level)",
                "showOpenInMe": true,
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Service Availability"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbookc56eee42-75de-44f2-a40d-45c819821abd",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServerSideLatencyGateway",
                    "aggregation": 4,
                    "columnName": "Latency Avg (ms)"
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServerSideLatencyGateway",
                    "aggregation": 3,
                    "columnName": "Latency Max (ms)"
                  }
                ],
                "title": "Server Side Latency by Collection - Avg & Max (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  },
                  {
                    "id": "3",
                    "key": "PublicAPIType",
                    "operator": 0,
                    "values": [
                      "mongoDB"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Server Side Latency by Collection"
            },
            {
              "type": 10,
              "content": {
                "chartId": "workbookfb6f57e3-8351-40e2-925e-0883851350ff",
                "version": "MetricsItem/2.0",
                "size": 0,
                "chartType": 2,
                "resourceType": "microsoft.documentdb/databaseaccounts",
                "metricScope": 0,
                "resourceIds": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-data-rg/providers/Microsoft.DocumentDB/databaseAccounts/${prefix}-${env_short}-${location_short}-${domain}-cosmos-account"
                ],
                "timeContextFromParameter": "evaluation_window",
                "timeContext": {
                  "durationMs": 604800000
                },
                "metrics": [
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServerSideLatencyGateway",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName",
                      "OperationType"
                    ],
                    "columnName": "Latency Avg by Collection & Op"
                  }
                ],
                "title": "Server Side Latency (Avg) by Collection & Operation (Database: activation)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "activation"
                    ]
                  },
                  {
                    "id": "3",
                    "key": "PublicAPIType",
                    "operator": 0,
                    "values": [
                      "mongoDB"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "Server Side Latency by Collection and Operation"
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "rtp-activator-db"
        },
        "name": "Activator"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "rtp-activator"
  },
  "name": "rtp-activator"
}
