{
  "type": 9,
  "content": {
    "version": "KqlParameterItem/1.0",
    "parameters": [
      {
        "id": "59922e7a-c4cd-45ce-817e-d22bb63909e1",
        "version": "KqlParameterItem/1.0",
        "name": "evaluation_window",
        "label": "Finestra di osservabilità",
        "type": 4,
        "typeSettings": {
          "selectableValues": [
            {
              "durationMs": 300000
            },
            {
              "durationMs": 3600000
            },
            {
              "durationMs": 86400000
            },
            {
              "durationMs": 259200000
            },
            {
              "durationMs": 604800000
            },
            {
              "durationMs": 1209600000
            },
            {
              "durationMs": 2592000000
            }
          ]
        },
        "timeContext": {
          "durationMs": 86400000
        },
        "value": {
          "durationMs": 604800000
        }
      }
    ],
    "style": "pills",
    "queryType": 0,
    "resourceType": "microsoft.operationalinsights/workspaces"
  },
  "name": "parameters - 2"
}