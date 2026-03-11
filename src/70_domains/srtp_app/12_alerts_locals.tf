locals {
  # ⚙️ Base configuration shared by all alerts
  base_alert_config = {
    enabled        = true
    severity       = 1
    frequency      = 5
    time_window    = 5
    data_source_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  }

  alerts_rtp = {
    # 🚨 Activations failure rate > 50% in the last 30 minutes
    rtp_activations_failure_rate_alert = {
      name        = "rtp-activations-failure-rate-alert"
      description = "Alert when the activation failure rate is strictly greater than 50% in the last 30 minutes"
      severity    = 0
      frequency   = 5
      time_window = 5
      query       = <<-QUERY
            AppRequests
            | where Name contains "POST /rtp/activation/activations"
            | summarize TotalRequests = count(), FailedRequests = countif(Success == false and ResultCode != "409")
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 5
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this critical alert
      action_groups = [
        azurerm_monitor_action_group.email.id,
        azurerm_monitor_action_group.slack.id
      ]
      email_subject = "[RTP][CRITICAL] Activation Failure Rate > 50%"
    }
  }

  # 🧱 Collection of alert groups
  alerts_groups = [
    local.alerts_rtp
  ]

  # ✅ Final alerts map ready for consumption
  final_alerts = merge([
    for alerts in local.alerts_groups : {
      for key, alert in alerts : key => merge(local.base_alert_config, alert)
    }
  ]...)
}
