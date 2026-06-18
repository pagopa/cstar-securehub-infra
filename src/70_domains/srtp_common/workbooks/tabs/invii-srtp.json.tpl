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
              "id": "72b30166-68e2-44d5-aaf5-a7c38aaabf51",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Consumer",
              "subTarget": "invii-consumer",
              "style": "link"
            },
            {
              "id": "dfc3ef65-3b89-42f5-b32a-1c039818197d",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Invii",
              "subTarget": "invii-invii",
              "style": "link"
            },
            {
              "id": "0834a705-c4c7-457c-9201-ffdef91e1420",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Cancellazioni",
              "subTarget": "invii-cancellazioni",
              "style": "link"
            },
            {
              "id": "7108d834-f396-4b5e-91bd-7c2e85f4962e",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Callback",
              "subTarget": "invii-callback",
              "style": "link"
            },
            {
              "id": "b1cdeaf4-25ec-42ee-8929-33fedd745f77",
              "cellValue": "tab",
              "linkTarget": "parameter",
              "linkLabel": "Sender Health Status",
              "subTarget": "invii-sender",
              "style": "link"
            }
          ]
        },
        "name": "links - invii-inner-7b5c71f7"
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"New GPD message received\"\n| summarize successCount = count()\n| extend totalRequestsString = tostring(successCount)",
                "size": 0,
                "title": "✅ Messaggi ingeriti con successo",
                "noDataMessageStyle": 5,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Messaggi ingeriti con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error processing message.\"\n| where not (Message contains \"rtp/gpd/message\")\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Messaggi scartati dal Consumer",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Messaggi scartati dal Consumer",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"New GPD message received\"\n| extend messageId = tostring(Properties.message_id)\n| where isnotempty(messageId)\n| summarize uniqueCount = dcount(messageId)\n| extend totalRequestsString = tostring(uniqueCount)",
                "size": 0,
                "title": "✅ Messaggi unici ingeriti con successo",
                "noDataMessageStyle": 5,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Messaggi unici ingeriti con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error processing message.\"\n| where not (Message contains \"rtp/gpd/message\")\n| extend messageId = tostring(Properties.message_id)\n| where isnotempty(messageId)\n| summarize uniqueCount = dcount(messageId)\n| extend totalRequestsString = tostring(uniqueCount)",
                "size": 0,
                "title": "❌ Messaggi unici scartati dal Consumer",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Messaggi unici scartati dal Consumer",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error processing message.\"\n| where Message contains \"rtp/gpd/message\"\n| summarize scartatiCount = count()\n| extend totalRequestsString = tostring(scartatiCount)",
                "size": 0,
                "title": "⚠️ Messaggi scartati per PayerId non attivo",
                "noDataMessageStyle": 5,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "⚠️ Messaggi scartati per PayerId non attivo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 9,
              "content": {
                "version": "KqlParameterItem/1.0",
                "parameters": [
                  {
                    "id": "c3d4e5f6-aaaa-bbbb-cccc-222233334444",
                    "version": "KqlParameterItem/1.0",
                    "name": "activations_bin_size",
                    "label": "Granularità temporale",
                    "type": 2,
                    "isRequired": true,
                    "typeSettings": {
                      "additionalResourceOptions": [],
                      "showDefault": false
                    },
                    "jsonData": "[{\"value\": \"5m\", \"label\": \"5 minuti\"}, {\"value\": \"15m\", \"label\": \"15 minuti\"}, {\"value\": \"1h\", \"label\": \"1 ora\"}, {\"value\": \"1d\", \"label\": \"1 giorno\"}, {\"value\": \"7d\", \"label\": \"7 giorni\"}]",
                    "value": "1h"
                  }
                ],
                "style": "pills",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces"
              },
              "name": "parameters - bin-size"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend messageId = tostring(Properties.message_id)\n| where isnotempty(messageId)\n| summarize\n    Successi = dcountif(messageId, Message startswith \"Message processed successfully\"),\n    Scartati = dcountif(messageId, Message startswith \"Error processing message.\" and not (Message contains \"rtp/gpd/message\"))\n  by bin(TimeGenerated, {activations_bin_size})\n| project TimeGenerated, Successi, Scartati\n",
                "size": 0,
                "title": "Andamento ingestione Consumer - Successi vs Scartati nel tempo",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "timechart"
              },
              "customWidth": "100",
              "name": "Andamento ingestione Consumer - Successi vs Scartati nel tempo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    operation       = extract(@\"operation=(\\w+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id)\n| summarize\n    [\"Consegne EVH\"]     = count(),\n    [\"Prima consegna\"]   = min(TimeGenerated),\n    [\"Ultima consegna\"]  = max(TimeGenerated),\n    [\"Operazione\"]       = take_any(operation),\n    [\"Status GPD\"]       = take_any(status),\n    [\"EC Tax Code\"]      = take_any(ec_tax_code),\n    [\"Debtor Tax Code\"]  = take_any(debtor_tax_code),\n    [\"IUV\"]              = take_any(iuv)\n    by msg_id\n| where [\"Consegne EVH\"] > 1\n| extend [\"Debtor Tax Code\"] = strcat(\n    substring([\"Debtor Tax Code\"], 0, 3),\n    substring(\"***********\", 0, strlen([\"Debtor Tax Code\"]) - 5),\n    substring([\"Debtor Tax Code\"], strlen([\"Debtor Tax Code\"]) - 2, 2)\n)\n| project\n    [\"Message ID\"]      = msg_id,\n    [\"Consegne EVH\"]    = [\"Consegne EVH\"],\n    [\"Prima consegna\"]  = [\"Prima consegna\"],\n    [\"Ultima consegna\"] = [\"Ultima consegna\"],\n    [\"Operazione\"]      = [\"Operazione\"],\n    [\"Status GPD\"]      = [\"Status GPD\"],\n    [\"EC Tax Code\"]     = [\"EC Tax Code\"],\n    [\"Debtor Tax Code\"] = [\"Debtor Tax Code\"],\n    [\"IUV\"]             = [\"IUV\"]\n| sort by [\"Consegne EVH\"] desc\n| limit 100",
                "size": 0,
                "title": "🔁 MessageId ricevuti più volte dall'EVH (duplicati di consegna)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "100",
              "name": "🔁 MessageId ricevuti più volte dall'EVH (duplicati di consegna)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| extend\n    msg_id = extract(@\"id=(\\d+)\", 1, Message),\n    operation = extract(@\"operation=(\\w+)\", 1, Message)\n| where isnotempty(msg_id) and isnotempty(operation);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Successo\"\n| summarize [\"Messaggi\"] = count() by [\"Operazione\"] = operation\n| sort by [\"Operazione\"] asc",
                "size": 0,
                "title": "✅ Messaggi processati con successo per Operazione (CREATE / UPDATE / DELETE)",
                "noDataMessageStyle": 5,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Messaggi processati con successo per Operazione",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| extend\n    msg_id = extract(@\"id=(\\d+)\", 1, Message),\n    operation = extract(@\"operation=(\\w+)\", 1, Message)\n| where isnotempty(msg_id) and isnotempty(operation);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| where not (Message startswith \"Error processing message.\" and Message contains \"rtp/gpd/message\")\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Errore\"\n| summarize [\"Messaggi\"] = count() by [\"Operazione\"] = operation\n| sort by [\"Operazione\"] asc",
                "size": 0,
                "title": "❌ Messaggi falliti per Operazione (CREATE / UPDATE / DELETE)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Messaggi falliti per Operazione",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=CREATE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Successo\"\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "✅ Ultimi 50 CREATE processati con successo",
                "noDataMessageStyle": 5,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Ultimi 50 CREATE processati con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=CREATE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Errore\"\n| where not (error_msg contains \"rtp/gpd/message\")\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv,\n    [\"Errore\"]          = error_msg\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "❌ Ultimi 50 CREATE falliti",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Ultimi 50 CREATE falliti",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=UPDATE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Successo\"\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "✅ Ultimi 50 UPDATE processati con successo",
                "noDataMessageStyle": 5,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Ultimi 50 UPDATE processati con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=UPDATE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Errore\"\n| where not (error_msg contains \"rtp/gpd/message\")\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv,\n    [\"Errore\"]          = error_msg\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "❌ Ultimi 50 UPDATE falliti",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Ultimi 50 UPDATE falliti",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=DELETE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Successo\"\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "✅ Ultimi 50 DELETE processati con successo",
                "noDataMessageStyle": 5,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Ultimi 50 DELETE processati con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| where Message contains \"operation=DELETE\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet outcomes = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend\n    msg_id = tostring(Properties.message_id),\n    esito  = iff(Message startswith \"Message processed successfully\", \"Successo\", \"Errore\"),\n    error_msg = iff(Message startswith \"Error\", trim(\" \", replace_string(Message, \"Error processing message.\", \"\")), \"\");\npayloads\n| join kind=inner outcomes on msg_id\n| where esito == \"Errore\"\n| where not (error_msg contains \"rtp/gpd/message\")\n| project\n    [\"Data\"]            = TimeGenerated1,\n    [\"Message ID\"]      = msg_id,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv,\n    [\"Errore\"]          = error_msg\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "❌ Ultimi 50 DELETE falliti",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table",
                "gridSettings": {
                  "sortBy": [
                    {
                      "itemKey": "Errore",
                      "sortOrder": 1
                    }
                  ]
                },
                "sortBy": [
                  {
                    "itemKey": "Errore",
                    "sortOrder": 1
                  }
                ]
              },
              "customWidth": "50",
              "name": "❌ Ultimi 50 DELETE falliti",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppExceptions\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| summarize\n    [\"Occorrenze\"] = count(),\n    [\"Ultimo messaggio\"] = arg_max(TimeGenerated, OuterMessage, OperationId)\n    by [\"Tipo eccezione\"] = ExceptionType\n| project\n    [\"Tipo eccezione\"],\n    [\"Occorrenze\"],\n    [\"Ultimo messaggio\"] = OuterMessage,\n    [\"Ultimo OperationId\"] = OperationId\n| sort by [\"Occorrenze\"] desc",
                "size": 0,
                "title": "Eccezioni Java rtp-consumer (AppExceptions)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "100",
              "name": "Eccezioni Java rtp-consumer (AppExceptions)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let statusLegend = datatable(statusCode: string, description: string)\n[\n    \"200\", \"OK - Successo\",\n    \"400\", \"Bad Request\",\n    \"401\", \"Unauthorized\",\n    \"403\", \"Forbidden\",\n    \"409\", \"Conflict - Idempotenza\",\n    \"422\", \"Unprocessable - Business error\",\n    \"499\", \"Client closed\",\n    \"503\", \"Service Unavailable\",\n    \"504\", \"Gateway Timeout\"\n];\nAzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/gpd/message'\n| where httpMethod_s == \"POST\"\n| summarize count() by statusCode = tostring(toint(httpStatus_d))\n| join kind=leftouter statusLegend on statusCode\n| project label = strcat(statusCode, \" - \", coalesce(description, \"Altro\")), count_\n| sort by count_ desc\n",
                "size": 0,
                "title": "Panoramica dei messaggi ricevuti sul sender con status code (APIM)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "piechart"
              },
              "customWidth": "100",
              "name": "Panoramica dei messaggi recevuti dal sender con status code",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error providing message to rtp-sender\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Messaggi falliti da Consumer a Sender",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "Messaggi falliti da Consumer a Sender",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message successfully provided to rtp-sender\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Messaggi inoltrati con successo al Sender",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Messaggi inoltrati con successo al Sender",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| extend retry_msg_id = extract(@\"message_id:\\s*(\\d+)\", 1, Message)\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Retry esauriti Consumer → Sender",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Retry esauriti Consumer → Sender",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let payloads = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    operation       = extract(@\"operation=(\\w+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id);\nlet retries_exhausted = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| extend\n    msg_id   = extract(@\"message_id:\\s*(\\d+)\", 1, Message),\n    attempts = extract(@\"attempts:\\s*(\\d+)\", 1, Message);\nlet errors = AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error providing message to rtp-sender\"\n| extend\n    msg_id    = tostring(Properties.message_id),\n    error_msg = extract(@\"message='([^']+)'\", 1, Message);\nretries_exhausted\n| join kind=leftouter payloads on msg_id\n| join kind=leftouter errors on msg_id\n| project\n    [\"Data\"]            = TimeGenerated,\n    [\"Message ID\"]      = msg_id,\n    [\"Tentativi\"]       = attempts,\n    [\"Operazione\"]      = operation,\n    [\"Status GPD\"]      = status,\n    [\"EC Tax Code\"]     = ec_tax_code,\n    [\"Debtor Tax Code\"] = debtor_tax_code,\n    [\"IUV\"]             = iuv,\n    [\"Errore\"]          = error_msg\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "❌ Retry esauriti Consumer → Sender",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ Retry esauriti Consumer → Sender - Copy",
              "styleSettings": {
                "showBorder": true
              }
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "invii-consumer"
        },
        "name": "invii-consumer"
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
                "query": " let saveLog = AppTraces\n | where TimeGenerated {evaluation_window:query}\n | where AppRoleName == \"rtp-sender\"\n | where Message startswith \"Rtp to be sent saved with id:\"\n | extend DebtorSP = extract(@\"service_provider:\\s*(\\S+)\", 1, Message)\n | project OperationId, DebtorSP;\n AppTraces\n | where TimeGenerated {evaluation_window:query}\n | where AppRoleName == \"rtp-sender\"\n | where Message startswith \"Rtp sent successfully with id:\"\n | join kind=inner saveLog on OperationId\n | summarize [\"Invii con successo\"] = count() by [\"Debtor Service Provider\"] = DebtorSP\n | sort by [\"Invii con successo\"] desc",
                "size": 0,
                "title": "✅ Invii con successo per Service Provider del debitore",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "barchart",
                "sortBy": [],
                "tileSettings": {
                  "showBorder": false,
                  "titleContent": {
                    "columnMatch": "Debtor Service Provider",
                    "formatter": 1
                  },
                  "leftContent": {
                    "columnMatch": "Invii con successo",
                    "formatter": 12,
                    "formatOptions": {
                      "palette": "auto"
                    },
                    "numberFormat": {
                      "unit": 17,
                      "options": {
                        "maximumSignificantDigits": 3,
                        "maximumFractionDigits": 2
                      }
                    }
                  }
                },
                "graphSettings": {
                  "type": 0,
                  "topContent": {
                    "columnMatch": "Debtor Service Provider",
                    "formatter": 1
                  },
                  "centerContent": {
                    "columnMatch": "Invii con successo",
                    "formatter": 1,
                    "numberFormat": {
                      "unit": 17,
                      "options": {
                        "maximumSignificantDigits": 3,
                        "maximumFractionDigits": 2
                      }
                    }
                  }
                },
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
                },
                "mapSettings": {
                  "locInfo": "LatLong",
                  "sizeSettings": "Invii con successo",
                  "sizeAggregation": "Sum",
                  "legendMetric": "Invii con successo",
                  "legendAggregation": "Sum",
                  "itemColorSettings": {
                    "type": "heatmap",
                    "colorAggregation": "Sum",
                    "nodeColorField": "Invii con successo",
                    "heatmapPalette": "greenRed"
                  }
                }
              },
              "name": "Invii con successo per Service Provider del debitore"
            },
            {
              "type": 9,
              "content": {
                "version": "KqlParameterItem/1.0",
                "parameters": [
                  {
                    "id": "c3d4e5f6-aaaa-bbbb-cccc-222233334444",
                    "version": "KqlParameterItem/1.0",
                    "name": "activations_bin_size",
                    "label": "Granularità temporale",
                    "type": 2,
                    "isRequired": true,
                    "typeSettings": {
                      "additionalResourceOptions": [],
                      "showDefault": false
                    },
                    "jsonData": "[{\"value\": \"5m\", \"label\": \"5 minuti\"}, {\"value\": \"15m\", \"label\": \"15 minuti\"}, {\"value\": \"1h\", \"label\": \"1 ora\"}, {\"value\": \"1d\", \"label\": \"1 giorno\"}, {\"value\": \"7d\", \"label\": \"7 giorni\"}]",
                    "value": "1h"
                  }
                ],
                "style": "pills",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces"
              },
              "name": "parameters - bin-size"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": " let ops = AppTraces\n | where TimeGenerated {evaluation_window:query}\n | where AppRoleName == \"rtp-sender\"\n | where Message startswith \"Operation: \"\n | extend Operation = extract(@\"Operation: (\\w+)\", 1, Message)\n | summarize Operation = any(Operation) by OperationId;\n let successes = AppTraces\n | where TimeGenerated {evaluation_window:query}\n | where AppRoleName == \"rtp-sender\"\n | where Message == \"Successfully processed message.\"\n | summarize TimeGenerated = min(TimeGenerated) by OperationId;\n let errors = AppTraces\n | where TimeGenerated {evaluation_window:query}\n | where AppRoleName == \"rtp-sender\"\n | where Message startswith \"Error processing message.\"\n | where Message !contains \"PayerNotActivatedException\"\n | where Message !contains \"InvalidTransitionException\"\n | where Message !contains \"RtpNotFoundException\"\n | summarize TimeGenerated = min(TimeGenerated) by OperationId;\n union\n     (successes | join kind=inner ops on OperationId | extend Series = strcat(\"✅ \", Operation)),\n     (errors    | join kind=inner ops on OperationId | extend Series = strcat(\"❌ \", Operation))\n | summarize Count = count() by bin(TimeGenerated, {activations_bin_size}), Series\n | render timechart",
                "size": 0,
                "title": "Invii RTP nel tempo (Successi vs Fallimenti) nel tempo",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "timechart",
                "chartSettings": {
                  "xSettings": {
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
              "name": "Invii RTP nel tempo (Successi vs Fallimenti) nel tempo"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let fallimenti = AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend _err = trim(\" \", replace_string(Message, \"Error sending Rtp to be sent:\", \"\"))\n| extend Categoria = case(\n    _err contains \"payer is not activated\",                \"⚠️ Payer non attivato\",\n    _err contains \"rejected\" or _err contains \"Reject\",   \"❌ Rejection SEPA\",\n    _err contains \"imeout\",                               \"❌ Timeout\",\n    _err contains \"Connection\" or _err contains \"refused\", \"❌ Errore di rete\",\n    _err contains \"MongoWrite\" or _err contains \"Mongo\"\n        or _err contains \"TooManyRequest\",                \"❌ Errore DB Mongo\",\n    _err contains \"PayeeNotFound\"\n        or _err contains \"ServiceProviderNotFound\",       \"❌ Payee/SP non trovato\",\n    _err contains \"InvalidTransition\"\n        or _err contains \"InvalidStatus\",                 \"❌ Transizione invalida\",\n    \"❌ Altro / non classificato\"\n)\n| summarize Conteggio = count() by Categoria;\nlet successi = AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 1\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize Conteggio = count()\n| extend Categoria = \"✅ Successo\";\nlet dettaglio = union fallimenti, successi;\nlet totaleFallimenti = toscalar(\n    dettaglio\n    | where Categoria startswith \"❌\" or Categoria startswith \"⚠️\"\n    | summarize sum(Conteggio)\n);\nlet totaleSuccessi = toscalar(\n    dettaglio\n    | where Categoria startswith \"✅\"\n    | summarize sum(Conteggio)\n);\ndettaglio\n| extend\n    TotaleFallimenti = totaleFallimenti,\n    TotaleSuccessi   = totaleSuccessi\n| sort by Conteggio desc",
                "size": 0,
                "title": "Monitoraggio di invii falliti o non processati per tipologia",
                "noDataMessageStyle": 3,
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
              "name": "Monitoraggio globale degli Invii RTP",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Invii totali con successo (APIM + CODA)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Invii totali con successo (APIM + CODA)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": " AppTraces\n | where AppRoleName == 'rtp-sender'\n | where TimeGenerated {evaluation_window:query}\n | where SeverityLevel == 3\n | where Message startswith \"Send RTP request rejected for\"\n | extend service_provider = extract(@\"Send RTP request rejected for ([^:]+):\", 1, Message)\n | extend rtp_operation_id = extract(@\"RTP Id:\\s*(\\d+)\", 1, Message)\n | project\n     TimeGenerated,\n     service_provider,\n     rtp_operation_id,\n     correlation_id = Properties[\"correlation_id\"],\n     resource_id    = Properties[\"resource_id\"]\n | top 100 by TimeGenerated desc",
                "size": 0,
                "title": "✅ Invii totali con successo (APIM + CODA)",
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "75",
              "name": "✅ Invii totali con successo (APIM + CODA)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Error sending Rtp to be sent:\"\n| where Message !contains \"payer is not activated\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errore nell'invio del RTP",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Invii falliti (Servizio) - Copy - Copy",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": " AppTraces\n | where AppRoleName == 'rtp-sender'\n | where TimeGenerated {evaluation_window:query}\n | where SeverityLevel == 3\n | where Message startswith \"Error sending Rtp to be sent:\"\n | where Message !contains \"payer is not activated\"\n | extend errorMessage = trim(\" \", replace_string(Message, \"Error sending Rtp to be sent:\", \"\"))\n | extend Categoria = case(\n     errorMessage contains \"TooMany\" or errorMessage contains \"429\",          \"Troppe richieste MongoDB\",\n     errorMessage contains \"DuplicateKey\" or errorMessage contains \"dup key\", \"Chiave duplicata MongoDB\",\n     errorMessage contains \"MongoWrite\" or errorMessage contains \"Mongo\",     \"Errore MongoDB\",\n     errorMessage contains \"imeout\",                                          \"Timeout\",\n     errorMessage contains \"Connection\" or errorMessage contains \"refused\",   \"Errore di rete\",\n     errorMessage contains \"rejected\" or errorMessage contains \"Reject\",      \"Rejection SEPA\",\n     \"Altro\"\n )\n | project\n     TimeGenerated,\n     Categoria,\n     errorMessage,\n     creditor_service_provider = Properties[\"creditor_service_provider\"],\n     correlation_id            = Properties[\"correlation_id\"],\n     resource_id               = Properties[\"resource_id\"]\n | top 250 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Catch-all errori invio",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "75",
              "name": "❌ Catch-all errori invio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": " AppTraces\n | where AppRoleName == 'rtp-sender'\n | where TimeGenerated {evaluation_window:query}\n | where SeverityLevel == 3\n | where Message startswith \"Send RTP request rejected for\"\n | extend service_provider = extract(@\"Send RTP request rejected for ([^:]+):\", 1, Message)\n | extend rtp_operation_id = extract(@\"RTP Id:\\s*(\\d+)\", 1, Message)\n | extend errorMessage     = trim(\" \", extract(@\"Send RTP request rejected for [^:]+:\\s*(.+)$\", 1, Message))\n | project\n     TimeGenerated,\n     service_provider,\n     rtp_operation_id,\n     errorMessage,\n     correlation_id = Properties[\"correlation_id\"],\n     resource_id    = Properties[\"resource_id\"]\n | top 250 by TimeGenerated desc",
                "size": 0,
                "title": "❌ REJECTION esplicita EPC",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ REJECTION esplicita EPC",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "\n AppTraces\n | where AppRoleName == 'rtp-sender'\n | where TimeGenerated {evaluation_window:query}\n | where SeverityLevel == 3\n | where Message startswith \"Error while handling RTP send for\"\n | extend resource_id_msg = extract(@\"Error while handling RTP send for ([^\\s]+)\", 1, Message)\n | extend errorMessage    = trim(\" \", extract(@\"Error while handling RTP send for [^\\s]+\\s(.+)$\", 1, Message))\n | project\n     TimeGenerated,\n     errorMessage,\n     resource_id               = coalesce(tostring(Properties[\"resource_id\"]), resource_id_msg),\n     creditor_service_provider = Properties[\"creditor_service_provider\"],\n     correlation_id            = Properties[\"correlation_id\"]\n | top 50 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errore Handler post retry",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ Errore Handler post retry",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Error saving Rtp to be sent:\"\n| where Message !contains \"payer is not activated\"\n| extend error_detail = trim(@\"\\.\", extract(@\"Error saving Rtp to be sent:\\s*(.+)$\", 1, Message))\n| extend Categoria = case(\n    error_detail contains \"TooMany\" or error_detail contains \"429\",          \"Troppe richieste MongoDB\",\n    error_detail contains \"DuplicateKey\" or error_detail contains \"dup key\", \"Chiave duplicata\",\n    error_detail contains \"MongoWrite\" or error_detail contains \"Write\",     \"Errore scrittura MongoDB\",\n    error_detail contains \"imeout\",                                          \"Timeout\",\n    error_detail contains \"Connection\" or error_detail contains \"refused\",   \"Errore connessione MongoDB\",\n    \"Altro\"\n)\n| project\n    TimeGenerated,\n    Categoria,\n    error_detail,\n    message_id     = Properties[\"message_id\"],\n    correlation_id = Properties[\"correlation_id\"],\n    resource_id    = Properties[\"resource_id\"]\n| top 50 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errore nel salvataggio a DB del RTP",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ Errore nel salvataggio a DB del RTP",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": " AppTraces\n | where AppRoleName == 'rtp-sender'\n | where TimeGenerated {evaluation_window:query}\n | where Message startswith \"Send RTP request rejected for\"\n | extend service_provider  = extract(@\"Send RTP request rejected for ([^:]+):\", 1, Message)\n | extend rtp_operation_id  = extract(@\"RTP Id:\\s*(\\d+)\", 1, Message)\n | project\n     TimeGenerated,\n     service_provider,\n     rtp_operation_id,\n     message_id     = Properties[\"message_id\"],\n     correlation_id = Properties[\"correlation_id\"],\n     resource_id    = Properties[\"resource_id\"]\n | top 50 by TimeGenerated desc",
                "size": 0,
                "title": "❌ RTP rifiutati dal Service Provider",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ RTP rifiutati dal Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"An unexpected error occurred while sending RTP\"\n| extend\n    service_provider = tostring(Properties[\"debtor_service_provider\"]),\n    error_msg        = extract(@\"Error:\\s*(.+)$\", 1, Message)\n| summarize\n    Errori             = count(),\n    [\"Ultimo errore\"]  = arg_max(TimeGenerated, error_msg)\n    by [\"Service Provider\"] = service_provider\n| sort by Errori desc",
                "size": 0,
                "title": "❌ Errori inattesi per Service Provider",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "❌ Errori inattesi per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"An unexpected error occurred while sending RTP\"\n| extend service_provider = extract(@\"to ([^\\s.]+)\\.\", 1, Message)\n| extend error_detail     = extract(@\"Error:\\s*(.+)$\", 1, Message)\n| extend Categoria = case(\n    error_detail contains \"imeout\",                                    \"Timeout\",\n    error_detail contains \"Connection\"\n        or error_detail contains \"refused\"\n        or error_detail contains \"Network\",                            \"Errore di rete\",\n    error_detail contains \"SSL\" or error_detail contains \"TLS\",        \"Errore SSL/TLS\",\n    error_detail contains \"reset\" or error_detail contains \"closed\",   \"Connessione chiusa\",\n    \"Altro\"\n)\n| project\n    TimeGenerated,\n    Categoria,\n    service_provider,\n    error_detail,\n    message_id     = Properties[\"message_id\"],\n    correlation_id = Properties[\"correlation_id\"],\n    resource_id    = Properties[\"resource_id\"]\n| top 50 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errori inattesi nell'invio",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ Errori inattesi nell'invio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"WebClientResponseException while fetching payees\"\n    or Message startswith \"An unexpected error occurred while fetching payees\"\n| extend Categoria = case(\n    Message startswith \"WebClientResponseException while fetching payees\",\n        strcat(\"HTTP \", extract(@\"Status Code\\s*:\\s*(\\S+)\", 1, Message)),\n    extract(@\"Error:\\s*(.+)\", 1, Message)\n)\n| project\n    TimeGenerated,\n    Categoria,\n    message_id     = Properties[\"message_id\"],\n    correlation_id = Properties[\"correlation_id\"],\n    resource_id    = Properties[\"resource_id\"]\n| top 50 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errori nel recupero della lista enti dal microservizio",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "statSettings": {
                  "valueField": "totalRequestsString",
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "name": "❌ Errori nel recupero della lista enti dal microservizio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppExceptions\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| summarize\n    [\"Occorrenze\"] = count(),\n    [\"Ultimo messaggio\"] = arg_max(TimeGenerated, OuterMessage, OperationId)\n    by [\"Tipo eccezione\"] = ExceptionType\n| project\n    [\"Tipo eccezione\"],\n    [\"Occorrenze\"],\n    [\"Ultimo messaggio\"] = OuterMessage,\n    [\"Ultimo OperationId\"] = OperationId\n| sort by [\"Occorrenze\"] desc",
                "size": 0,
                "title": "Eccezioni Java rtp-sender (AppExceptions)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "100",
              "name": "Eccezioni Java rtp-sender (AppExceptions)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| extend ServiceProvider = tostring(Properties.debtor_service_provider)\n| extend ServiceProvider = iff(isempty(ServiceProvider), \"N/A\", ServiceProvider)\n| summarize retries = count() by ServiceProvider\n| order by retries desc\n",
                "size": 0,
                "title": "Retry per invii SRTP",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "name": "Retry per invii SRTP",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let Sent =\nAppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize sentCount = count()\n| extend key = 1;\n\nlet PaidThroughOtherChannel =\nAppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message has \"Successfully updated paid RTP with different psp scenario\"\n| extend pspBic = coalesce(extract(@\"PSP BIC:\\s*([^,\\s}]+)\", 1, Message), \"unknown\")\n| summarize paidOtherCount = count(), distinctPsp = dcountif(pspBic, pspBic != \"unknown\")\n| extend key = 1;\n\nSent\n| join kind=fullouter PaidThroughOtherChannel on key\n| extend sentCount = coalesce(sentCount, 0),\n         paidOtherCount = coalesce(paidOtherCount, 0),\n         distinctPsp = coalesce(distinctPsp, 0)\n| extend paidOtherPercentage = iff(sentCount > 0, 100.0 * todouble(paidOtherCount) / todouble(sentCount), 0.0)\n| project [\"RTP inviati\"] = sentCount,\n          [\"RTP pagati attraverso altro canale\"] = paidOtherCount,\n          [\"PSP distinti\"] = distinctPsp,\n          [\"% pagati attraverso altro canale\"] = paidOtherPercentage\n",
                "size": 0,
                "title": "RTP pagati tramite altro canale",
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "gridSettings": {
                  "sortBy": [
                    {
                      "itemKey": "RTP pagati attraverso altro canale",
                      "sortOrder": 1
                    }
                  ]
                },
                "sortBy": [
                  {
                    "itemKey": "RTP pagati attraverso altro canale",
                    "sortOrder": 1
                  }
                ]
              },
              "name": "query - 19",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message hasprefix \"Successfully got payee name\"\n| parse Message with \"Successfully got payee name \" payeeName \" for the payee id \" payeeId\n| summarize ['RTP Count'] = count(), ['Payee Ids'] = make_set(payeeId, 100) by ['Payee Name'] = tostring(payeeName)\n| order by ['RTP Count'] desc\n",
                "size": 0,
                "title": "✅ Successo nel recupero del payee name per payee ID",
                "noDataMessageStyle": 5,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "✅ Successo nel recupero del payee name per payee ID",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error getting payee name from payee registry for the payee id\"\n| extend payeeId = tostring(Properties[\"payee_id\"])\n| summarize ['Error Count'] = count() by ['Payee Id'] = payeeId\n| extend ['Total Requests'] = tostring(['Error Count'])\n",
                "size": 0,
                "title": "❌ Errore nel recupero del payee ID dal payee registry",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Errore nel recupero del payee ID dal payee registry",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Rtp sent successfully with id: \"\n| summarize [\"Invii Effettuati\"] = count() by [\"Payee Name\"] = tostring(Properties.payee_name)\n| sort by [\"Invii Effettuati\"] desc\n",
                "size": 0,
                "title": "✅ Invii con successo per Ente Creditore",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "Invii con successo per Ente Creditore",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Error finding activation data with resourceId:\" or Message startswith \"Error saving Rtp to be sent:\" or Message startswith \"Error sending Rtp to be sent:\"\n| extend payee_name = tostring(Properties.payee_name)\n| summarize [\"Errori\"] = count() by [\"Payee Name\"] = payee_name\n| sort by [\"Errori\"] desc\n",
                "size": 0,
                "title": "❌ Invii falliti per Ente Creditore",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "Invii falliti per Ente Creditore",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message contains \"Message discarded due to out of order timestamp\"\n| parse Message with * \"messageTimestamp: \" messageTimestamp \n                       \", lastProcessedTimestamp: \" lastProcessedTimestamp \n                       \", status: \" status\n                       \", operation: \" operation\n                       \", id: \" id\n| extend \n    message_time = unixtime_milliseconds_todatetime(tolong(messageTimestamp)),\n    last_processed_time = unixtime_milliseconds_todatetime(tolong(lastProcessedTimestamp)),\n    time_difference = tolong(lastProcessedTimestamp) - tolong(messageTimestamp)\n| project \n    ['Log Time'] = TimeGenerated,\n    ['Message Time'] = message_time, \n    ['Last Processed Time'] = last_processed_time, \n    ['Time Difference Milliseconds'] = time_difference,\n    ['Time Difference Days'] = time_difference / (1000 * 60 * 60 * 24),\n    ['Message Timestamp'] = messageTimestamp, \n    ['Last Processed Timestamp'] = lastProcessedTimestamp,\n    ['Status'] = status, \n    ['Operation'] = operation, \n    ['Message Id'] = id\n| order by ['Log Time'] desc\n",
                "size": 0,
                "title": "❌ Messaggi scartati per Out-of-order Timestamp",
                "noDataMessageStyle": 3,
                "timeContext": {
                  "durationMs": 2592000000
                },
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "❌ Messaggi scartati per Out-of-order Timestamp"
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "invii-invii"
        },
        "name": "invii-invii"
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
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Message startswith \"RTP cancellation succeeded\"\n| extend DebtorSP = extract(@\"service_provider:\\s*(\\S+)\", 1, Message)\n| where isnotempty(DebtorSP)\n| summarize [\"Cancellazioni con successo\"] = count() by [\"Debtor Service Provider\"] = DebtorSP\n| sort by [\"Cancellazioni con successo\"] desc",
                "size": 0,
                "title": "✅ Cancellazioni con successo per Service Provider del debitore",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "barchart",
                "sortBy": [],
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
              "name": "✅ Cancellazioni con successo per Service Provider del debitore"
            },
            {
              "type": 9,
              "content": {
                "version": "KqlParameterItem/1.0",
                "parameters": [
                  {
                    "id": "c3d4e5f6-aaaa-bbbb-cccc-222233334444",
                    "version": "KqlParameterItem/1.0",
                    "name": "activations_bin_size",
                    "label": "Granularità temporale",
                    "type": 2,
                    "isRequired": true,
                    "typeSettings": {
                      "additionalResourceOptions": [],
                      "showDefault": false
                    },
                    "jsonData": "[{\"value\": \"5m\", \"label\": \"5 minuti\"}, {\"value\": \"15m\", \"label\": \"15 minuti\"}, {\"value\": \"1h\", \"label\": \"1 ora\"}, {\"value\": \"1d\", \"label\": \"1 giorno\"}, {\"value\": \"7d\", \"label\": \"7 giorni\"}]",
                    "value": "1h"
                  }
                ],
                "style": "pills",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces"
              },
              "name": "parameters - bin-size"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let successes = AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Message startswith \"RTP cancellation succeeded\"\n| extend DebtorSP = extract(@\"service_provider:\\s*(\\S+)\", 1, Message)\n| summarize TimeGenerated = min(TimeGenerated) by OperationId, DebtorSP;\nlet errors = AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Message startswith \"Error cancel RTP:\"\n| extend DebtorSP = extract(@\"service_provider:\\s*(\\S+)\", 1, Message)\n| summarize TimeGenerated = min(TimeGenerated) by OperationId, DebtorSP;\nunion\n    (successes | extend Series = strcat(\"✅ \", DebtorSP)),\n    (errors    | extend Series = strcat(\"❌ \", DebtorSP))\n| summarize Count = count() by bin(TimeGenerated, {activations_bin_size}), Series\n| render timechart",
                "size": 0,
                "title": "Cancellazioni nel tempo (Successi vs Fallimenti) nel tempo",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "timechart",
                "chartSettings": {
                  "xSettings": {
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
              "name": "Cancellazioni nel tempo (Successi vs Fallimenti) nel tempo"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let fallimenti = AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancel RTP:\"\n| extend _err = trim(\" \", extract(@\"Error cancel RTP:\\s*(.+?)\\. service_provider:\", 1, Message))\n| extend Categoria = case(\n    _err contains \"rejected\" or _err contains \"Reject\",    \"❌ Rejection SEPA\",\n    _err contains \"imeout\",                                \"❌ Timeout\",\n    _err contains \"Connection\" or _err contains \"refused\", \"❌ Errore di rete\",\n    _err contains \"Mongo\" or _err contains \"TooManyRequest\", \"❌ Errore DB Mongo\",\n    _err contains \"NotFound\" or _err contains \"not found\",  \"❌ RTP non trovato\",\n    _err contains \"InvalidTransition\" or _err contains \"InvalidStatus\", \"❌ Transizione invalida\",\n    \"❌ Altro / non classificato\"\n)\n| summarize Conteggio = count() by Categoria\n| extend Tipo = \"Fallimento\";\nlet successi = AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"RTP cancellation succeeded\"\n| summarize Conteggio = count()\n| extend Categoria = \"✅ Successo\", Tipo = \"Successo\";\nlet dettaglio = union fallimenti, successi;\nlet totali = dettaglio\n| summarize Conteggio = sum(Conteggio) by Tipo\n| extend Categoria = strcat(\"📊 Totale \", Tipo);\nunion dettaglio, totali\n| project Categoria, Tipo, Conteggio\n| sort by Tipo asc, Conteggio desc",
                "size": 0,
                "title": "Monitoraggio globale delle Cancellazioni per tipologia",
                "noDataMessageStyle": 3,
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
              "name": "Monitoraggio globale delle Cancellazioni per tipologia",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"RTP cancellation succeeded\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Cancellazioni totali con successo",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Cancellazioni totali con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancel RTP:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Cancellazioni totali fallite",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Cancellazioni totali fallite",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Retry esauriti (cancellazioni SRTP)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Retry esauriti (cancellazioni SRTP)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Handling SendRequestRejectedException during RTP cancellation\"\n| project\n    TimeGenerated,\n    resource_id               = Properties[\"resource_id\"],\n    debtor_service_provider   = Properties[\"debtor_service_provider\"],\n    creditor_service_provider = Properties[\"creditor_service_provider\"],\n    payee_name                = Properties[\"payee_name\"],\n    correlation_id            = Properties[\"correlation_id\"],\n    Message\n| top 100 by TimeGenerated desc",
                "size": 0,
                "title": "❌ REJECTION EPC anomala durante cancellazione (RJCT imprevisto)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "❌ REJECTION EPC anomala durante cancellazione (RJCT imprevisto)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Error cancel RTP:\"\n| extend errorMessage = trim(\" \", extract(@\"Error cancel RTP:\\s*(.+?)\\. service_provider:\", 1, Message))\n| extend service_provider = extract(@\"service_provider:\\s*(\\S+)\", 1, Message)\n| extend Categoria = case(\n    errorMessage contains \"TooMany\" or errorMessage contains \"429\",          \"Troppe richieste MongoDB\",\n    errorMessage contains \"DuplicateKey\" or errorMessage contains \"dup key\", \"Chiave duplicata MongoDB\",\n    errorMessage contains \"MongoWrite\" or errorMessage contains \"Mongo\",     \"Errore MongoDB\",\n    errorMessage contains \"imeout\",                                          \"Timeout\",\n    errorMessage contains \"Connection\" or errorMessage contains \"refused\",   \"Errore di rete\",\n    errorMessage contains \"rejected\" or errorMessage contains \"Reject\",      \"Rejection SEPA\",\n    \"Altro\"\n)\n| project\n    TimeGenerated,\n    Categoria,\n    service_provider,\n    errorMessage,\n    correlation_id = Properties[\"correlation_id\"],\n    resource_id    = Properties[\"resource_id\"]\n| top 250 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Catch-all errori cancellazione per tipologia",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "❌ Catch-all errori cancellazione per tipologia",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"An unexpected error occurred while cancelling RTP\"\n| extend\n    service_provider = tostring(Properties[\"debtor_service_provider\"]),\n    error_msg        = extract(@\"Error:\\s*(.+)$\", 1, Message)\n| summarize\n    Errori = count(),\n    arg_max(TimeGenerated, error_msg)\n    by [\"Service Provider\"] = service_provider\n| project [\"Service Provider\"], Errori, [\"Ultimo errore\"] = error_msg\n| sort by Errori desc",
                "size": 0,
                "title": "❌ Errori inattesi per Service Provider (cancellazioni)",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "❌ Errori inattesi per Service Provider (cancellazioni)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"An unexpected error occurred while cancelling RTP\"\n| extend error_detail = extract(@\"Error:\\s*(.+)$\", 1, Message)\n| extend Categoria = case(\n    error_detail contains \"imeout\",                                     \"Timeout\",\n    error_detail contains \"Connection\"\n        or error_detail contains \"refused\"\n        or error_detail contains \"Network\",                             \"Errore di rete\",\n    error_detail contains \"SSL\" or error_detail contains \"TLS\",         \"Errore SSL/TLS\",\n    error_detail contains \"reset\" or error_detail contains \"closed\",    \"Connessione chiusa\",\n    \"Altro\"\n)\n| project\n    TimeGenerated,\n    Categoria,\n    debtor_service_provider   = Properties[\"debtor_service_provider\"],\n    creditor_service_provider = Properties[\"creditor_service_provider\"],\n    error_detail,\n    correlation_id = Properties[\"correlation_id\"],\n    resource_id    = Properties[\"resource_id\"]\n| top 100 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errori inattesi nella cancellazione — dettaglio",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "❌ Errori inattesi nella cancellazione — dettaglio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Successfully cancelled draft RTP\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Cancellazioni draft con successo (GPD UPDATE_DRAFT)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "✅ Cancellazioni draft con successo (GPD UPDATE_DRAFT)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancelling draft RTP:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errori cancellazioni draft (GPD UPDATE_DRAFT)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "25",
              "name": "❌ Errori cancellazioni draft (GPD UPDATE_DRAFT)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where SeverityLevel == 3\n| where Message startswith \"Error cancelling draft RTP:\"\n| project\n    TimeGenerated,\n    debtor_service_provider   = Properties[\"debtor_service_provider\"],\n    creditor_service_provider = Properties[\"creditor_service_provider\"],\n    resource_id               = Properties[\"resource_id\"],\n    correlation_id            = Properties[\"correlation_id\"],\n    Message\n| top 100 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Errori cancellazioni draft — dettaglio",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "❌ Errori cancellazioni draft — dettaglio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Triggering CANCEL transition for RTP\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Callback CNCL — CANCEL confermati",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "50",
              "name": "✅ Callback CNCL — CANCEL confermati",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Triggering ERROR_CANCEL transition for RTP\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Callback RJCR — CANCEL rifiutati",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "stat",
                "statSettings": {
                  "valueAggregation": "None",
                  "colorSettings": {
                    "type": "static",
                    "mode": "background",
                    "heatmapPalette": "greenRed",
                    "thresholdsGrid": []
                  },
                  "iconSettings": {
                    "thresholdsGrid": []
                  },
                  "numberFormatSettings": {
                    "unit": 0,
                    "options": {
                      "style": "decimal"
                    }
                  },
                  "tagText": "",
                  "valueFontStyle": "auto"
                }
              },
              "customWidth": "50",
              "name": "❌ Callback RJCR — CANCEL rifiutati",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where (Message startswith \"Extraction error:\" or Message startswith \"No valid confirmation status found\")\n| extend TipoErrore = case(\n    Message startswith \"Extraction error:\", \"❌ Estrazione campo fallita\",\n    \"⚠️ Status di conferma non trovato\"\n)\n| project\n    TimeGenerated,\n    TipoErrore,\n    debtor_service_provider = Properties[\"debtor_service_provider\"],\n    resource_id             = Properties[\"resource_id\"],\n    correlation_id          = Properties[\"correlation_id\"],\n    Message\n| top 100 by TimeGenerated desc",
                "size": 0,
                "title": "❌ Callback cancellazioni — errori parsing",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "❌ Callback cancellazioni — errori parsing",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppExceptions\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where (\n    OuterMessage contains \"cancel\" or OuterMessage contains \"Cancel\"\n    or OuterMessage contains \"DELETE\" or OuterMessage contains \"cancell\"\n    or InnermostType contains \"Cancel\" or InnermostType contains \"Delete\"\n)\n| project\n    TimeGenerated,\n    InnermostType,\n    OuterMessage,\n    resource_id             = tostring(Properties[\"resource_id\"]),\n    debtor_service_provider = tostring(Properties[\"debtor_service_provider\"]),\n    ExceptionType\n| top 100 by TimeGenerated desc",
                "size": 0,
                "title": "Eccezioni Java rtp-sender — flusso cancellazione",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "Eccezioni Java rtp-sender — flusso cancellazione",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| extend ServiceProvider = tostring(Properties.debtor_service_provider)\n| extend ServiceProvider = iff(isempty(ServiceProvider), \"N/A\", ServiceProvider)\n| summarize retries = count() by ServiceProvider\n| order by retries desc",
                "size": 0,
                "title": "Retry per cancellazioni SRTP — per Service Provider",
                "noDataMessageStyle": 3,
                "showExportToExcel": true,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "Retry per cancellazioni SRTP — per Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "invii-cancellazioni"
        },
        "name": "invii-cancellazioni"
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
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/cb/send'\n| summarize count() by tostring(toint(httpStatus_d))\n",
                "size": 0,
                "title": "Callback totali ricevute e relativi status code",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
              "customWidth": "50",
              "name": "Callback totali ricevute e relativi status code",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == \"/rtp/cb/send\"\n| where toint(httpStatus_d) != 200\n| summarize count() by tostring(toint(httpStatus_d))",
                "size": 0,
                "title": "Errori HTTP callback",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
              "customWidth": "50",
              "name": "Errori HTTP callback",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| where Message contains \"Send callback processed successfully\"\n| extend props = parse_json(Properties)\n| extend certificate_serial_number = tolower(tostring(props.certificate_serial_number))\n| extend tsp_id =\n    case(\n        certificate_serial_number == tolower(\"6A7672BD13DAEEBEA96A2E1D\"), \"08992631005\",\n        certificate_serial_number == tolower(\"57491023a5f86649d08c873c\"), \"PPAYITR1XXX\",\n        certificate_serial_number == tolower(\"99999999999999999999999999999999\"), \"FAKESP01\",\n        certificate_serial_number == tolower(\"0d2e7840f6bd10f83b0a0fdefe63084e\"), \"ICRAITRRXXX\",\n        certificate_serial_number == tolower(\"0526412432649C97549B74C18143F264CC42\"), \"09591661005\",\n        certificate_serial_number == tolower(\"3f820e1702687b7fa32de266c234422c\"), \"HYEEIT22XXX\",\n        certificate_serial_number == tolower(\"51972BDC627D4B3C6D5F48D15E722154\"), \"MOCKSP04\",\n        certificate_serial_number\n    )\n| summarize callbackCount = count() by tsp_id\n| render barchart kind=unstacked\n",
                "size": 0,
                "title": "✅ Callback per Service Provider con successo",
                "noDataMessageStyle": 5,
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
              "name": "✅ Callback per Service Provider con successo"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-activator\"\n| where Message startswith \"Certificate mismatch: expected \"\n| extend CertificareSerialNumber = tolower(tostring(Properties.certificate_serial_number))\n| extend CertificareSerialNumber = iff(isempty(CertificareSerialNumber), \"N/A\", CertificareSerialNumber)\n| extend mapped =\n    case(\n        CertificareSerialNumber == tolower(\"6A7672BD13DAEEBEA96A2E1D\"), \"08992631005\",\n        CertificareSerialNumber == tolower(\"57491023a5f86649d08c873c\"), \"PPAYITR1XXX\",\n        CertificareSerialNumber == tolower(\"99999999999999999999999999999999\"), \"FAKESP01\",\n        CertificareSerialNumber == tolower(\"0d2e7840f6bd10f83b0a0fdefe63084e\"), \"ICRAITRRXXX\",\n        CertificareSerialNumber == tolower(\"0526412432649C97549B74C18143F264CC42\"), \"09591661005\",\n        CertificareSerialNumber == tolower(\"3f820e1702687b7fa32de266c234422c\"), \"HYEEIT22XXX\",\n        CertificareSerialNumber == tolower(\"51972BDC627D4B3C6D5F48D15E722154\"), \"MOCKSP04\",\n        CertificareSerialNumber\n    )\n| summarize [\"Numero di Mismatch\"] = count() by [\"Certificate Serial Number\"] = mapped\n| order by [\"Numero di Mismatch\"] desc\n",
                "size": 4,
                "title": "Numero di mismatch del seriale del certificato",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "name": "Numero di mismatch del seriale del certificato"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-activator'\n| where Message startswith \"Certificate mismatch: expected \"\n| project TimeGenerated, Message",
                "size": 0,
                "title": "Elenco dei mismatch dei certificati",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "gridSettings": {
                  "formatters": [
                    {
                      "columnMatch": "Message",
                      "formatter": 0,
                      "formatOptions": {
                        "customColumnWidthSetting": "110ch"
                      }
                    }
                  ]
                }
              },
              "name": "Elenco dei mismatch dei certificati"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Processing transaction status:\"\n| extend\n    tx_status = extract(@\"Processing transaction status: (\\w+)\", 1, Message)\n| summarize\n    [\"Callback\"] = count()\n    by [\"Transaction Status\"] = tx_status\n| sort by [\"Callback\"] desc",
                "size": 0,
                "title": "Breakdown status callback ricevute (ACCP / RJCT / ACWC / ...)",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "unstackedbar"
              },
              "customWidth": "100",
              "name": "Breakdown status callback ricevute (ACCP / RJCT / ACWC / ...)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 9,
              "content": {
                "version": "KqlParameterItem/1.0",
                "parameters": [
                  {
                    "id": "2fe6d2e4-8c64-4688-8585-7e269d9231ec",
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
                      ]
                    },
                    "jsonData": "[\n    { \"value\": \"UNCRITMM\", \"label\": \"Unicredit\" },\n    { \"value\": \"ICRAITRRXXX\", \"label\": \"ICCREA\" },\n    { \"value\": \"BNCMITRR\", \"label\": \"Bancomat\" },\n    { \"value\": \"FAKESP01\", \"label\": \"FAKESP01\" },\n    { \"value\": \"MOCKSP01\", \"label\": \"MOCKSP01\" },\n    { \"value\": \"MOCKSP04\", \"label\": \"MOCKSP04\" },\n    { \"value\": \"PPAYITR1XXX\", \"label\": \"Poste\" },\n    { \"value\": \"HYEEIT22XXX\", \"label\": \"Hype\" },\n    { \"value\": \"TAKEOV01\", \"label\": \"TAKEOV01\" }\n]",
                    "timeContext": {
                      "durationMs": 86400000
                    },
                    "value": [
                      "value::all"
                    ]
                  }
                ],
                "style": "pills",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces"
              },
              "name": "parameters - 5"
            }
          ]
        },
        "conditionalVisibility": {
          "parameterName": "tab",
          "comparison": "isEqualTo",
          "value": "invii-callback"
        },
        "name": "invii-callback"
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
            },
            {
              "type": 1,
              "content": {
                "json": "## 📊 Cosmos DB - Shared Throughput Analysis\n---\n**Come leggere questa griglia:**\n\n| Colonna | Cosa indica | Quando preoccuparsi |\n|---|---|---|\n| **Total RU Consumed** | Costo effettivo in Request Units per collection | Una collection consuma >80% del totale |\n| **Mongo Requests** | Numero di operazioni MongoDB | Rapporto requests/documenti molto alto (es. polling) |\n| **Document Count** | Numero di documenti nella collection | — |\n| **Data Usage / Index Usage** | Storage dati e indici | Data Usage sproporzionato rispetto al Document Count |\n| **Normalized RU %** | % di utilizzo del throughput condiviso (0-100%) | >70% = attenzione, >90% = throttling imminente |\n| **Autoscale Max Throughput** | RU massime configurate (a livello database) | Se Normalized RU è costantemente alto, aumentare questo valore |\n| **Throttled (429/16500)** | Richieste rifiutate per throughput insufficiente | Qualsiasi valore >0 indica un problema attivo |\n\n⚠️ **Nota:** Il throughput è **shared a livello database** — tutte le collection competono per le stesse RU. Se una collection domina il consumo, le altre possono subire throttling."
              },
              "name": "text - rtp-throughput-info"
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
                "title": "Cosmos DB - Shared Throughput Analysis (Database: rtp)",
                "gridFormatType": 2,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
              "showPin": false,
              "name": "CosmosDB Account Metrics"
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
                "title": "Normalized RU Consumption & RU Cost by Collection (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Total RU Consumed & Throttling by Collection (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Total RU Cost by Collection & Operation Type (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "MongoDB Requests by Collection, Command & Error Code (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "2",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Failed Requests by Collection, Error Code & Command (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "3",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Data & Index Usage by Collection (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Server Side Latency by Collection - Avg & Max (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
                "title": "Server Side Latency (Avg) by Collection & Operation (Database: rtp)",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "DatabaseName",
                    "operator": 0,
                    "values": [
                      "rtp"
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
          "value": "invii-sender"
        },
        "name": "invii-sender"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "invii"
  },
  "name": "INVII RTP"
}
