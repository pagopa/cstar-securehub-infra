[
  {
    "partition_key": "generic",
    "entity": [
      {
        "id": "srtp-recover-gpd-messages",
        "name": "SRTP - Recover failed GPD messages",
        "description": "Re-send the failed GPD messages stored in the rtp_failed_messages Cosmos DB collection to the RTP API, discarding the notices that are no longer payable",
        "runbook": "srtp/recover_gpd_messages.py",
        "run_args": "--env dev --limit 100",
        "worker": "generic",
        "oncall": false,
        "require_approval": true,
        "tags": "srtp,rtp,recovery"
      }
    ]
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
