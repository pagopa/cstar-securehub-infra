[
  {
    "partition_key": "generic",
    "entity": []
  },
  {
    "partition_key": "infra",
    "entity": [
      {
        "id": "carbon-monthly-emissions-report",
        "name": "Carbon dashboard - Refresh emissions data",
        "description": "Fetch the Carbon Optimization monthly report for the pagoPA subscriptions and publish it to the carbon dashboard",
        "runbook": "carbon/fetch_carbon_report.py",
        "run_args": "--storage-account pagopaditncarbonfe",
        "worker": "generic",
        "oncall": false,
        "require_approval": false,
        "tags": "carbon,azure"
      }
    ]
  },
  {
    "partition_key": "alert",
    "entity": []
  }
]
