{
  "type": 12,
  "content": {
    "version": "NotebookGroup/1.0",
    "groupType": "editable",
    "title": "Invii SRTP",
    "items": [
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
          "visualization": "stat"
        },
        "name": "✅ Invii totali con successo (APIM + CODA)",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) == 201\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
          "size": 0,
          "title": "✅ Invii totali con successo passando da APIM",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ],
          "visualization": "stat",
          "gridSettings": {
            "formatters": [
              {
                "columnMatch": "Totale",
                "formatter": 1
              }
            ]
          },
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
            "tagText": "",
            "valueFontStyle": "auto",
            "valueField": "totalRequestsString"
          }
        },
        "customWidth": "25",
        "name": "Invii totali con successo ",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) !in (201,200)\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
          "size": 0,
          "title": "❌ Invii totali falliti  passando da APIM",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
        "name": "Invii totali falliti",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where httpMethod_s == \"POST\"\n| summarize count() by tostring(toint(httpStatus_d))",
          "size": 0,
          "title": "Panoramica degli invii totali con status code passando da APIM",
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
        "name": "Panoramica degli invii totali con status code",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n| where toint(httpStatus_d) !in (201,200,500,404,422,400)\n| where httpMethod_s == \"POST\"\n| summarize totalRequests = count()\n| extend totalRequestsString = tostring(totalRequests)",
          "size": 0,
          "title": "❌ Invii falliti (APIM)",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ],
          "visualization": "stat",
          "sortBy": [],
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
        "name": "Invii totali falliti apim",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error finding activation data with resourceId:\" or Message startswith \"Error saving Rtp to be sent:\" or Message startswith \"Error sending Rtp to be sent:\"\n| summarize errorCount = count()\n| extend totalRequestsString = tostring(errorCount)",
          "size": 0,
          "title": "❌ Invii falliti da apim e da coda",
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
        "type": 9,
        "content": {
          "version": "KqlParameterItem/1.0",
          "parameters": [],
          "style": "pills",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces"
        },
        "name": "parameters - 10"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s == '/rtp/rtps'\n and httpMethod_s == \"POST\"\n| summarize \n    Successo   = countif(httpStatus_d == 201),\n    Fallimento = countif(httpStatus_d !in (201,200))\n  by bin(TimeGenerated, 1h)\n| project TimeGenerated, Successo, Fallimento\n| render timechart\n",
          "size": 0,
          "title": "Invii nel tempo (Successi vs Fallimenti)",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
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
        "name": "Invii nel tempo (Successi vs Fallimenti)"
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
          "query": "AppTraces\n| where AppRoleName == 'rtp-sender'\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith \"Error sending Rtp to be sent:\"\n| extend reource_id = tostring(Properties.resource_id)\n| summarize errorCount = count() by reource_id\n| project-rename \n    [\"RTP id\"] = reource_id,\n    [\"Errori\"]              = errorCount\n| sort by [\"Errori\"] desc",
          "size": 0,
          "title": "❌ Invii falliti per RTP resource id",
          "noDataMessageStyle": 3,
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
        "name": "Invii falliti per RTP resource id"
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppTraces\n| where TimeGenerated {evaluation_window:query}\n| where AppRoleName == 'rtp-sender'\n| where Message startswith \"Rtp sent successfully with id: \"\n| summarize [\"Invii Effettuati\"] = count() by [\"Payee Name\"] = tostring(Properties.payee_name)\n| sort by [\"Invii Effettuati\"] desc\n",
          "size": 0,
          "title": "✅Invii con successo per Ente Creditore",
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
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/rtps\"\n| where httpStatus_d in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
          "size": 0,
          "title": "✅ Status code dei successi degli invii per Client IP",
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ],
          "visualization": "table"
        },
        "customWidth": "50",
        "name": "Status code dei successi degli invii per Client IP",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AzureDiagnostics\n| where TimeGenerated {evaluation_window:query}\n| where requestUri_s contains \"/rtp/rtps\"\n| where httpStatus_d !in (200, 201)\n| summarize Count = count() by clientIP_s, HttpStatus = httpStatus_d\n| project-rename \n    [\"Client IP\"] = clientIP_s, \n    [\"Http Status Code\"] = HttpStatus,\n    [\"Count\"] = Count\n| order by [\"Count\"] desc\n",
          "size": 0,
          "title": "❌ Status code dei successi degli invii per Client IP",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-monitor-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-law"
          ]
        },
        "customWidth": "50",
        "name": "Status code dei successi degli invii per Client IP",
        "styleSettings": {
          "showBorder": true
        }
      },
      {
        "type": 3,
        "content": {
          "version": "KqlItem/1.0",
          "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message contains \"Message discarded due to out of order timestamp\"\n| parse Message with * \"messageTimestamp: \" messageTimestamp \n                       \", lastProcessedTimestamp: \" lastProcessedTimestamp \n                       \", status: \" status \n                       \", operation: \" operation \n                       \", id: \" id\n| extend \n    message_time = unixtime_milliseconds_todatetime(tolong(messageTimestamp)),\n    last_processed_time = unixtime_milliseconds_todatetime(tolong(lastProcessedTimestamp)),\n    time_difference = tolong(lastProcessedTimestamp) - tolong(messageTimestamp)\n| project \n    ['Log Time'] = TimeGenerated,\n    ['Message Time'] = message_time, \n    ['Last Processed Time'] = last_processed_time, \n    ['Time Difference Milliseconds'] = time_difference,\n    ['Time Difference Days'] = time_difference / (1000 * 60 * 60 * 24),\n    ['Message Timestamp'] = messageTimestamp, \n    ['Last Processed Timestamp'] = lastProcessedTimestamp,\n    ['Status'] = status, \n    ['Operation'] = operation, \n    ['Message Id'] = id\n| order by ['Log Time'] desc\n",
          "size": 0,
          "title": "❌ Messaggi scartati per Out-of-order Timestamp",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ]
        },
        "name": "❌ Messaggi scartati per Out-of-order Timestamp"
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
          "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message hasprefix \"Successfully got payee name\"\n| parse Message with \"Successfully got payee name \" payeeName \" for the payee id \" payeeId\n| summarize ['RTP Count'] = count(), ['Payee Ids'] = make_set(payeeId, 100) by ['Payee Name'] = tostring(payeeName)\n| order by ['RTP Count'] desc\n",
          "size": 0,
          "title": "✅ Successo nel recupero del payee name per payee ID",
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
          "query": "AppTraces\n| where AppRoleName == \"rtp-sender\"\n| where TimeGenerated {evaluation_window:query}\n| where Message startswith_cs \"DELETE_GDP_RTP_NOT_FOUND\"\n| summarize ErrorCount = count() by bin(TimeGenerated, 5m)\n| order by TimeGenerated asc\n",
          "size": 0,
          "title": "❌ Delete fallite su RTP non presenti a DB",
          "noDataMessageStyle": 3,
          "queryType": 0,
          "resourceType": "microsoft.operationalinsights/workspaces",
          "crossComponentResources": [
            "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${env_short}-${location_short}-${domain}-monitoring-rg/providers/Microsoft.OperationalInsights/workspaces/${prefix}-${env_short}-${location_short}-${domain}-law"
          ]
        },
        "name": "query - 18"
      }
    ]
  },
  "conditionalVisibility": {
    "parameterName": "tab",
    "comparison": "isEqualTo",
    "value": "invii"
  },
  "name": "Invii SRTP"
}