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
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\"\n| summarize successCount = count()\n| extend totalRequestsString = tostring(successCount)",
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\"\n| extend messageId = tostring(Properties.message_id)\n| where isnotempty(messageId)\n| summarize uniqueCount = dcount(messageId)\n| extend totalRequestsString = tostring(uniqueCount)",
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
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully\" or Message startswith \"Error processing message.\"\n| extend messageId = tostring(Properties.message_id)\n| where isnotempty(messageId)\n| summarize\n    Successi = dcountif(messageId, Message startswith \"Message processed successfully\"),\n    Scartati = dcountif(messageId, Message startswith \"Error processing message.\" and not (Message contains \"rtp/gpd/message\"))\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successi, Scartati\n| render timechart",
                "size": 0,
                "title": "Andamento ingestione Consumer — Successi vs Scartati (univoci, bin 1h)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "100",
              "name": "Andamento ingestione Consumer — Successi vs Scartati (univoci)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Payload:\"\n| extend\n    msg_id          = extract(@\"id=(\\d+)\", 1, Message),\n    operation       = extract(@\"operation=(\\w+)\", 1, Message),\n    status          = extract(@\"status=([A-Z_]+)\", 1, Message),\n    ec_tax_code     = extract(@\"ec_tax_code=([^,\\]]+)\", 1, Message),\n    debtor_tax_code = extract(@\"debtor_tax_code=([^,\\]]+)\", 1, Message),\n    iuv             = extract(@\"iuv=([^,\\]]+)\", 1, Message)\n| where isnotempty(msg_id)\n| summarize\n    [\"Consegne EVH\"]     = count(),\n    [\"Prima consegna\"]   = min(TimeGenerated),\n    [\"Ultima consegna\"]  = max(TimeGenerated),\n    [\"Operazione\"]       = take_any(operation),\n    [\"Status GPD\"]       = take_any(status),\n    [\"EC Tax Code\"]      = take_any(ec_tax_code),\n    [\"Debtor Tax Code\"]  = take_any(debtor_tax_code),\n    [\"IUV\"]              = take_any(iuv)\n    by msg_id\n| where [\"Consegne EVH\"] > 1\n| project\n    [\"Message ID\"]      = msg_id,\n    [\"Consegne EVH\"]    = [\"Consegne EVH\"],\n    [\"Prima consegna\"]  = [\"Prima consegna\"],\n    [\"Ultima consegna\"] = [\"Ultima consegna\"],\n    [\"Operazione\"]      = [\"Operazione\"],\n    [\"Status GPD\"]      = [\"Status GPD\"],\n    [\"EC Tax Code\"]     = [\"EC Tax Code\"],\n    [\"Debtor Tax Code\"] = [\"Debtor Tax Code\"],\n    [\"IUV\"]             = [\"IUV\"]\n| sort by [\"Consegne EVH\"] desc\n| limit 100",
                "size": 0,
                "title": "🔁 MessageId ricevuti più volte dall'EVH (duplicati di consegna)",
                "noDataMessageStyle": 5,
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
                "noDataMessageStyle": 3,
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
                "query": "AppExceptions\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| summarize\n    [\"Occorrenze\"] = count(),\n    [\"Ultimo messaggio\"] = arg_max(TimeGenerated, OuterMessage)\n    by [\"Tipo eccezione\"] = ExceptionType\n| sort by [\"Occorrenze\"] desc",
                "size": 0,
                "title": "Eccezioni Java rtp-consumer (AppExceptions)",
                "noDataMessageStyle": 3,
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
                "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains 'rtp/gpd/message'\n| where httpMethod_s == \"POST\"\n| summarize count() by tostring(toint(httpStatus_d))",
                "size": 0,
                "title": "Panoramica dei messaggi ricevuti sul sender con status code (APIM)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
                ],
                "visualization": "piechart"
              },
              "customWidth": "25",
              "name": "Panoramica dei messaggi recevuti dal sender con status code",
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-consumer'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Retries exhausted after attempts\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Message processed successfully, rtp created with id\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Messaggi ricevuti dal Sender tramite Consumer",
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
              "name": "Messaggi inviati da Consumer a Sender",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error while processing GPD message for requestId\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Fallimenti ricezione messaggi Sender da Consumer",
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
              "name": "Messaggi falliti da Consumer a Sender - Copy",
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error finding activation data with resourceId:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ RTP non creato - attivazione inesistente per il Codice Fiscale",
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
              "name": "❌ Invii falliti (Servizio)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error saving Rtp to be sent:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errore nel salvataggio a DB del RTP",
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
              "name": "❌ Invii falliti (Servizio) - Copy",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Send RTP request rejected for\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ RTP rifiutati dal Service Provider",
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
              "name": "❌ RTP rifiutati dal Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"An unexpected error occurred while sending RTP\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errori inattesi nell'invio",
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
              "name": "❌ Errori inattesi nell'invio",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error retrieving registry data\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errori Registry Service Provider",
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
              "name": "❌ Errori Registry Service Provider",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error while getting Payees list\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Errori Payee Registry",
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
              "name": "❌ Errori Payee Registry",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend _err = trim(\" \", replace_string(Message, \"Error sending Rtp to be sent:\", \"\"))\n| extend Categoria = case(\n    _err contains \"payer is not activated\",              \"Payer non attivato\",\n    _err contains \"rejected\" or _err contains \"Reject\",  \"Rejection SEPA\",\n    _err contains \"imout\" or _err contains \"Timeout\",    \"Timeout\",\n    _err contains \"Connection\" or _err contains \"refused\",\"Errore di rete\",\n    _err contains \"MongoWrite\" or _err contains \"Mongo\",  \"Errore DB Mongo\",\n    \"Altro / non classificato\"\n)\n| summarize Errori = count() by Categoria\n| sort by Errori desc",
                "size": 0,
                "title": "Classificazione errori di invio per tipo",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart"
              },
              "customWidth": "50",
              "name": "Classificazione errori di invio per tipo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppExceptions\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| summarize\n    [\"Occorrenze\"] = count(),\n    [\"Ultimo messaggio\"] = arg_max(TimeGenerated, OuterMessage)\n    by [\"Tipo eccezione\"] = ExceptionType\n| sort by [\"Occorrenze\"] desc",
                "size": 0,
                "title": "Eccezioni Java rtp-sender (AppExceptions)",
                "noDataMessageStyle": 3,
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Send RTP request rejected for\"\n| extend\n    service_provider = extract(@\"Send RTP request rejected for (\\S+):\", 1, Message),\n    rejection_reason = extract(@\"Send RTP request rejected for \\S+: (.+)$\", 1, Message)\n| summarize\n    [\"Rifiuti\"] = count(),\n    [\"Ultimo motivo\"] = arg_max(TimeGenerated, rejection_reason)\n    by [\"Service Provider\"] = service_provider\n| sort by [\"Rifiuti\"] desc",
                "size": 0,
                "title": "❌ RTP rifiutati per Service Provider (dettaglio)",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ RTP rifiutati per Service Provider (dettaglio)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"An unexpected error occurred while sending RTP\"\n| extend\n    service_provider = tostring(Properties.serviceProviderDebtor),\n    error_msg = extract(@\"Error: (.+)$\", 1, Message)\n| summarize\n    [\"Errori\"] = count(),\n    [\"Ultimo errore\"] = arg_max(TimeGenerated, error_msg)\n    by [\"Service Provider\"] = service_provider\n| sort by [\"Errori\"] desc",
                "size": 0,
                "title": "❌ Errori inattesi per Service Provider (dettaglio)",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Errori inattesi per Service Provider (dettaglio)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| extend\n    rtp_id     = extract(@\"Rtp sent successfully with id: (\\S+)\", 1, Message),\n    resource_id = tostring(Properties.resource_id),\n    payee_name  = tostring(Properties.payee_name)\n| project\n    [\"Data\"]           = TimeGenerated,\n    [\"RTP ID\"]         = rtp_id,\n    [\"Resource ID\"]    = resource_id,\n    [\"Ente Creditore\"] = payee_name\n| sort by [\"Data\"] desc\n| limit 250",
                "size": 0,
                "title": "✅ Ultimi invii con successo per Resource ID - Limit 250",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Ultimi invii con successo per Resource ID",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend\n    resource_id = tostring(Properties.resource_id),\n    errorMessage = replace_string(Message, \"Error sending Rtp to be sent:\", \"\")\n| where errorMessage !contains \"The payer is not activated\"\n| summarize\n    errorCount = count(),\n    lastError = arg_max(TimeGenerated, errorMessage)\n        by resource_id\n| project-rename\n    [\"RTP id\"] = resource_id,\n    [\"Errori\"] = errorCount,\n    [\"Ultimo errore\"] = lastError\n| sort by [\"Errori\"] desc\n| limit 250",
                "size": 0,
                "title": "❌ Invii falliti per RTP Resource ID (Errori Generici) - Limit 250",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "Invii falliti per RTP resource id (Errori Generici)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend\n    resource_id = tostring(Properties.resource_id),\n    errorMessage = replace_string(Message, \"Error sending Rtp to be sent:\", \"\")\n| where errorMessage contains \"The payer is not activated\"\n| summarize\n    errorCount = count(),\n    lastError = arg_max(TimeGenerated, errorMessage)\n        by resource_id\n| project-rename\n    [\"RTP id\"] = resource_id,\n    [\"Errori\"] = errorCount,\n    [\"Ultimo errore\"] = lastError\n| sort by [\"Errori\"] desc\n| limit 250",
                "size": 0,
                "title": "❌ Invii falliti per RTP Resource ID (Payer Non Attivato) - Limit 250",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "Invii falliti per RTP resource id (Payer Non Attivato)",
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
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-core-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-core-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Retry per invii SRTP",
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
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| summarize\n    Successo   = countif(Message startswith \"Rtp sent successfully with id:\"),\n    Errori     = countif(\n                    Message startswith \"Error finding activation data with resourceId:\" \n                    or Message startswith \"Error saving Rtp to be sent:\" \n                    or Message startswith \"Error sending Rtp to be sent:\"\n                 )\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Errori\n| render timechart\n",
                "size": 0,
                "title": "Invii RTP nel tempo (Successi vs Fallimenti) in bin 1 ora",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
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
              "name": "query - 12"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize \n    [\"Invii con successo\"] = count() \n  by \n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Invii con successo\"] desc\n",
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
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "let Sent =\nAppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| summarize sentCount = count()\n| extend key = 1;\n\nlet PaidThroughOtherChannel =\nAppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message has \"Successfully updated paid RTP with different psp scenario\"\n| extend pspBic = coalesce(extract(@\"PSP BIC:\\s*([^,\\s}]+)\", 1, Message), \"unknown\")\n| summarize paidOtherCount = count(), distinctPsp = dcountif(pspBic, pspBic != \"unknown\")\n| extend key = 1;\n\nSent\n| join kind=fullouter PaidThroughOtherChannel on key\n| extend sentCount = coalesce(sentCount, 0),\n         paidOtherCount = coalesce(paidOtherCount, 0),\n         distinctPsp = coalesce(distinctPsp, 0)\n| extend paidOtherPercentage = iff(sentCount > 0, 100.0 * todouble(paidOtherCount) / todouble(sentCount), 0.0)\n| project [\"RTP inviati\"] = sentCount,\n          [\"RTP pagati attraverso altro canale\"] = paidOtherCount,\n          [\"PSP distinti\"] = distinctPsp,\n          [\"% pagati attraverso altro canale\"] = paidOtherPercentage\n",
                "size": 0,
                "title": "RTP pagati tramite altro canale",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
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
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Rtp sent successfully with id:\"\n| extend\n    rtp_id     = extract(@\"Rtp sent successfully with id: (\\S+)\", 1, Message),\n    resource_id = tostring(Properties.resource_id),\n    payee_name  = tostring(Properties.payee_name)\n| project\n    [\"Data\"]           = TimeGenerated,\n    [\"RTP ID\"]         = rtp_id,\n    [\"Resource ID\"]    = resource_id,\n    [\"Ente Creditore\"] = payee_name\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "✅ Ultimi 50 invii con successo",
                "noDataMessageStyle": 5,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "✅ Ultimi 50 invii con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n    or Message startswith \"Error finding activation data with resourceId:\"\n    or Message startswith \"Error saving Rtp to be sent:\"\n| extend\n    resource_id = tostring(Properties.resource_id),\n    payee_name  = tostring(Properties.payee_name),\n    raw_msg     = trim(\" \", Message)\n| extend Categoria = case(\n    raw_msg contains \"payer is not activated\",             \"Payer non attivato\",\n    raw_msg contains \"rejected\" or raw_msg contains \"Reject\", \"Rejection SEPA\",\n    raw_msg contains \"imout\" or raw_msg contains \"Timeout\",   \"Timeout\",\n    raw_msg contains \"Connection\" or raw_msg contains \"refused\", \"Errore di rete\",\n    raw_msg contains \"MongoWrite\" or raw_msg contains \"Mongo\",   \"Errore DB Mongo\",\n    raw_msg contains \"activation data\",                   \"Attivazione non trovata\",\n    \"Altro\"\n)\n| project\n    [\"Data\"]            = TimeGenerated,\n    [\"Resource ID\"]     = resource_id,\n    [\"Ente Creditore\"]  = payee_name,\n    [\"Categoria\"]       = Categoria,\n    [\"Messaggio errore\"] = raw_msg\n| sort by [\"Data\"] desc\n| limit 50",
                "size": 0,
                "title": "❌ Ultimi 50 fallimenti invio",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "❌ Ultimi 50 fallimenti invio",
              "styleSettings": {
                "showBorder": true
              }
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
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Successfully cancelled RTP to service provider debtor\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Cancellazioni totali con successo (CODA + API)",
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
              "name": "✅ Cancellazioni totali con successo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancel RTP:\" or Message startswith \"Error retrieving RTP:\"\n// \"Error retrieving RTP:\" -> API log\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Cancellazioni totali falliti (CODA + API)",
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
              "name": "❌ Cancellazioni totali falliti",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith_cs \"DELETE_GDP_RTP_NOT_FOUND\"\n| extend\n    OperationId    = extract(@\"operationId=(\\d+)\", 1, Message),\n    EventDispatcher = extract(@\"eventDispatcher=([^,]+)\", 1, Message),\n    GdpMessageId   = extract(@\"gdpMessageId=(\\d+)\", 1, Message)\n| project\n    ['Time Generated']  = TimeGenerated,\n    ['Operation Id']    = OperationId,\n    ['Event Dispatcher'] = EventDispatcher,\n    ['GDP Message Id']  = GdpMessageId,\n    ['Message']         = Message\n| order by ['Time Generated'] desc\n",
                "size": 0,
                "title": "❌ Delete fallite su RTP non presenti a DB",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ]
              },
              "customWidth": "50",
              "name": "query - 18",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == \"rtp-sender\"\n| summarize\n    Successo   = countif(Message hasprefix \"Successfully cancelled RTP to service provider debtor\"),\n    Fallimento = countif(Message hasprefix \"Error cancel RTP:\")\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart",
                "size": 0,
                "title": "Cancellazioni nel tempo (Successi vs Fallimenti)",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
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
              "name": "Cancellazioni nel tempo (Successi vs Fallimenti)"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"RTP cancellation succeeded\" \n| summarize\n    [\"Cancellazioni con successo\"] = count()\n   by\n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Cancellazioni con successo\"] desc\n",
                "size": 0,
                "title": "✅ Cancellazioni con successo per Service Provider",
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
              "name": "✅ Cancellazioni con successo per Service Provider"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Error cancel RTP\" \n| summarize\n    [\"Cancellazioni con fallimento\"] = count()\n   by\n    [\"Debtor Service Provider\"] = tostring(Properties.service_provider)\n| sort by [\"Cancellazioni con fallimento\"] desc",
                "size": 0,
                "title": "❌ Cancellazioni fallite per Service Provider",
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table",
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
              "name": "❌ Cancellazioni fallite per Service Provider"
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Successfully cancelled draft RTP with id:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "✅ Cancellazioni draft con successo (GPD DELETE)",
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
              "name": "✅ Cancellazioni draft con successo (GPD DELETE)",
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
                "title": "❌ Errori cancellazioni draft (GPD DELETE)",
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
              "name": "❌ Errori cancellazioni draft (GPD DELETE)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Handling SendRequestRejectedException during RTP cancellation\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
                "size": 0,
                "title": "❌ Cancellazioni anomale (RJCT imprevisto)",
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
              "name": "❌ Cancellazioni anomale (RJCT imprevisto)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Start processing INVALID update\"\n    or Message startswith \"Start processing EXPIRED update\"\n| extend\n    event_type = extract(@\"Start processing (\\w+) update\", 1, Message),\n    rtp_id = extract(@\"rtpId=([^,\\s]+)\", 1, Message)\n| summarize\n    [\"Totale\"] = count()\n    by [\"Tipo evento GPD\"] = event_type\n| sort by [\"Totale\"] desc",
                "size": 0,
                "title": "Cancellazioni per evento GPD (INVALID / EXPIRED)",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Cancellazioni per evento GPD (INVALID / EXPIRED)",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error cancel RTP:\"\n    or Message startswith \"Error cancelling draft RTP:\"\n| extend _err = trim(\" \", coalesce(\n    replace_string(Message, \"Error cancel RTP:\", \"\"),\n    replace_string(Message, \"Error cancelling draft RTP:\", \"\")\n))\n| extend Categoria = case(\n    _err contains \"imout\" or _err contains \"Timeout\",    \"Timeout\",\n    _err contains \"400\"   or _err contains \"Bad Request\", \"4xx Service Provider\",\n    _err contains \"500\"   or _err contains \"Server Error\",\"5xx Service Provider\",\n    _err contains \"not found\" or _err contains \"404\",     \"RTP non trovato\",\n    _err contains \"MongoWrite\" or _err contains \"Mongo\",  \"Errore DB Mongo\",\n    \"Altro / non classificato\"\n)\n| summarize Errori = count() by Categoria\n| sort by Errori desc",
                "size": 0,
                "title": "Classificazione errori di cancellazione per tipo",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "piechart"
              },
              "customWidth": "50",
              "name": "Classificazione errori di cancellazione per tipo",
              "styleSettings": {
                "showBorder": true
              }
            },
            {
              "type": 3,
              "content": {
                "version": "KqlItem/1.0",
                "query": "AppExceptions\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where ExceptionType !contains \"WebClientResponseException\"\n| summarize\n    [\"Occorrenze\"] = count(),\n    [\"Ultimo messaggio\"] = arg_max(TimeGenerated, OuterMessage)\n    by [\"Tipo eccezione\"] = ExceptionType\n| sort by [\"Occorrenze\"] desc",
                "size": 0,
                "title": "Eccezioni Java rtp-sender — flusso cancellazione",
                "noDataMessageStyle": 3,
                "queryType": 0,
                "resourceType": "microsoft.operationalinsights/workspaces",
                "crossComponentResources": [
                  "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
                ],
                "visualization": "table"
              },
              "customWidth": "50",
              "name": "Eccezioni Java rtp-sender — flusso cancellazione",
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
              "type": 10,
              "content": {
                "chartId": "workbook9ee57fd6-b139-4730-ac8b-ae263ee8cb58",
                "version": "MetricsItem/2.0",
                "size": 1,
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
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-MongoRequests",
                    "aggregation": 7,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5,
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
                    "splitByLimit": 5
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                    "aggregation": 4,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
                    "aggregation": 3,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                    "aggregation": 3,
                    "splitBy": [
                      "CollectionName"
                    ],
                    "splitBySortOrder": -1,
                    "splitByLimit": 5,
                    "columnName": "Highest RU Consuming Shard"
                  }
                ],
                "title": "Cosmos DB Account Metrics By Collection",
                "gridFormatType": 2,
                "filters": [
                  {
                    "id": "1",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  },
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
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-TotalRequests",
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
                          "useGrouping": false,
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-TotalRequests Timeline",
                      "formatter": 9,
                      "formatOptions": {
                        "min": 0,
                        "palette": "blue",
                        "aggregation": "Sum"
                      }
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
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "purple",
                        "aggregation": "Max"
                      },
                      "numberFormat": {
                        "unit": 17,
                        "options": {
                          "style": "decimal",
                          "useGrouping": false,
                          "maximumFractionDigits": 1
                        }
                      }
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption",
                      "formatter": 8,
                      "formatOptions": {
                        "min": 0,
                        "palette": "blue",
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
                      "columnMatch": "microsoft.documentdb/databaseaccounts-Requests-NormalizedRUConsumption Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Mongo Client Requests Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Highest RU Consuming Shard Timeline",
                      "formatter": 5
                    },
                    {
                      "columnMatch": "Highest RU Consuming Shard",
                      "formatter": 1,
                      "numberFormat": {
                        "unit": 1,
                        "options": null
                      }
                    },
                    {
                      "columnMatch": "Mongo Client Requests",
                      "formatter": 1,
                      "numberFormat": {
                        "unit": 0,
                        "options": null
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
                      "columnId": "Mongo Client Requests",
                      "label": "Mongo Client Requests"
                    },
                    {
                      "columnId": "Mongo Client Requests Timeline",
                      "label": "Mongo Client Requests Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount",
                      "label": "Document Count (Avg)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DocumentCount Timeline",
                      "label": "Document Count (Avg) Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage",
                      "label": "Data Usage (Average)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-DataUsage Timeline",
                      "label": "Data Usage (Average) Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                      "label": "Index Usage (Average)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage Timeline",
                      "label": "Index Usage (Average) Timeline"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput",
                      "label": "Provisioned Throughput (Max)"
                    },
                    {
                      "columnId": "microsoft.documentdb/databaseaccounts-Requests-ProvisionedThroughput Timeline",
                      "label": "Provisioned Throughput (Max) Timeline"
                    },
                    {
                      "columnId": "Highest RU Consuming Shard",
                      "label": "Highest RU Consuming Shard"
                    },
                    {
                      "columnId": "Highest RU Consuming Shard Timeline",
                      "label": "Highest RU Consuming Shard Timeline"
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
                    ]
                  }
                ],
                "title": "Highest RU Consuming Shard RTP",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  },
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
              "showPin": false,
              "name": "NormalizedRUConsumption"
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
                    "aggregation": 1
                  }
                ],
                "title": "Total RUs RTP",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  },
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
              "showPin": false,
              "name": "metric - 5"
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
                      "OperationType"
                    ]
                  }
                ],
                "title": "Total RUs by Request Type",
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
                    "id": "2",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "metric - 10"
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
                      "CommandName"
                    ],
                    "columnName": "MongoDB Client Requests"
                  }
                ],
                "title": "Client Requests RTP",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  },
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
              "name": "metric - 3"
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
                      "CommandName"
                    ]
                  }
                ],
                "title": "Failed Client Requests by Operation Type RTP",
                "showOpenInMe": true,
                "filters": [
                  {
                    "id": "1",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  },
                  {
                    "id": "2",
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
              "name": "metric - 4"
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
                    "aggregation": 1
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-IndexUsage",
                    "aggregation": 1
                  }
                ],
                "title": "Data & Index Usage",
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
                    "id": "2",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
                    ]
                  }
                ],
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "name": "metric - 6"
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
                    "aggregation": 4
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
                    "aggregation": 2
                  },
                  {
                    "namespace": "microsoft.documentdb/databaseaccounts",
                    "metric": "microsoft.documentdb/databaseaccounts-Requests-ServiceAvailability",
                    "aggregation": 3
                  }
                ],
                "title": "Service Availability (min/max/avg in %)",
                "gridSettings": {
                  "rowLimit": 10000
                }
              },
              "showPin": false,
              "name": "metric - 7"
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
                    "splitBy": [
                      "Region"
                    ]
                  }
                ],
                "title": "Server Side Latency (Avg) By Region RTP",
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
                    "id": "2",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
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
              "customWidth": "50",
              "name": "metric - 8",
              "styleSettings": {
                "maxWidth": "50",
                "showBorder": true
              }
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
                      "OperationType"
                    ]
                  }
                ],
                "title": " Server Side Latency (Avg) By Operation RTP",
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
                    "id": "2",
                    "key": "CollectionName",
                    "operator": 0,
                    "values": [
                      "rtps"
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
              "customWidth": "50",
              "name": "metric - 9",
              "styleSettings": {
                "maxWidth": "50",
                "showBorder": true
              }
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
