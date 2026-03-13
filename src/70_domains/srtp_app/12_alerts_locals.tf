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
      frequency   = 30
      time_window = 30
      query       = <<-QUERY
            AppRequests
            | where AppRoleName == "rtp-activator"
            | where Name startswith "POST" and Name contains "activations"
            | summarize TotalRequests = count(), FailedRequests = countif(Success == false and ResultCode != "409")
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 50
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this critical alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP][CRITICAL] Activation Failure Rate > 50%"
    }

    # 🚨 Deactivations failure rate > 50% in the last 30 minutes
    rtp_deactivations_failure_rate_alert = {
      name        = "rtp-deactivations-failure-rate-alert"
      description = "Alert when the deactivation failure rate is strictly greater than 50% in the last 30 minutes"
      severity    = 0
      frequency   = 30
      time_window = 30
      query       = <<-QUERY
            AppRequests
            | where AppRoleName == "rtp-activator"
            | where Name has "DELETE" and Name contains "activations"
            | summarize TotalRequests = count(), FailedRequests = countif(Success == false)
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 50
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this critical alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP][CRITICAL] Deactivation Failure Rate > 50%"
    }

    # 🚨 Takeovers failure rate > 50% in the last 30 minutes
    rtp_takeovers_failure_rate_alert = {
      name        = "rtp-takeovers-failure-rate-alert"
      description = "Alert when the takeover failure rate is strictly greater than 50% in the last 30 minutes"
      severity    = 0
      frequency   = 30
      time_window = 30
      query       = <<-QUERY
            let excluded_takeovers = AppTraces
              | where AppRoleName == "rtp-activator"
              | where Message startswith "OTP expired due to expiration time exceeded"
                  or Message startswith "Request rejected due to nonexistent OTP"
              | summarize by OperationId;
            AppRequests
            | where AppRoleName == "rtp-activator"
            | where Name startswith "POST" and Name contains "takeover"
            | join kind=leftouter excluded_takeovers on OperationId
            | summarize TotalRequests = count(), FailedRequests = countif(Success == false and isempty(OperationId1))
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 50
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this critical alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP][CRITICAL] Takeover Failure Rate > 50%"
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
