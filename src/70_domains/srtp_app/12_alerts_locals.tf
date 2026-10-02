locals {
  # ⚙️ Base configuration shared by all alerts
  base_alert_config = {
    enabled        = true
    severity       = 1
    frequency      = 5
    time_window    = 5
    data_source_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
    location       = null
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

    # 🚨 0 messages consumed by rtp-consumer in the last 30 minutes
    rtp_consumer_zero_messages_alert = {
      name        = "rtp-consumer-zero-messages-alert"
      description = "Alert when the rtp-consumer microservice consumes 0 messages in the last 30 minutes"
      severity    = 1
      frequency   = 30
      time_window = 30
      query       = <<-QUERY
        AppTraces
        | where AppRoleName == "rtp-consumer"
        | where Message startswith "New GPD message received" or Message startswith "Error processing message."
      QUERY
      trigger = {
        operator  = "LessThanOrEqual"
        threshold = 0
      }
      # Use both email and slack for this alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-CONSUMER][WARNING] 0 messages consumed by rtp-consumer in the last 30 minutes"
    }

    # 🚨 GPD Message API 4xx Error
    rtp_gpd_message_4xx_alert = {
      name           = "rtp-gpd-message-4xx-alert"
      description    = "Alert when the GPD Message API returns a generic 4xx error code (excluding 401, 403, 404, 409, 422, 499) with a rate > 10%"
      severity       = 1
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.log_analytics_workspace.location
      query          = <<-QUERY
            let excluded_requests = AppTraces
              | where AppRoleName == "rtp-sender"
              | where Message has "Size.gpdMessageDtoMono.description" or Message has "Size.gpdMessageDtoMono.subject"
              | distinct OperationId;
            AppRequests
            | where Url contains "rtp/gpd/message"
            | where Name startswith "POST"
            | join kind=leftanti excluded_requests on OperationId
            | summarize TotalRequests = count(), FailedRequests = countif(toint(ResultCode) >= 400 and toint(ResultCode) < 500 and toint(ResultCode) !in (401, 403, 404, 409, 422, 499))
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 10
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [WARNING] GPD Message API 4xx Error Rate > 10%"
    }

    # 🚨 GPD Message API 401 Error
    rtp_gpd_message_401_alert = {
      name           = "rtp-gpd-message-401-alert"
      description    = "Alert when the GPD Message API returns a 401 (Unauthorized) error code"
      severity       = 1
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 401
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [WARNING] GPD Message API 401 Unauthorized Error"
    }

    # 🚨 GPD Message API 403 Error
    rtp_gpd_message_403_alert = {
      name           = "rtp-gpd-message-403-alert"
      description    = "Alert when the GPD Message API returns a 403 (Forbidden) error code"
      severity       = 1
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 403
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [WARNING] GPD Message API 403 Forbidden Error"
    }

    # 🚨 GPD Message API 5xx Error
    rtp_gpd_message_5xx_alert = {
      name           = "rtp-gpd-message-5xx-alert"
      description    = "Alert when the GPD Message API returns a generic 5xx error code (excluding 502, 503, 504) with a rate > 10%"
      severity       = 0
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | summarize TotalRequests = count(), FailedRequests = countif(toint(httpStatus_d) >= 500 and toint(httpStatus_d) !in (502, 503, 504))
            | extend FailureRate = (todouble(FailedRequests) / todouble(TotalRequests)) * 100
            | where FailureRate > 10
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      # Use both email and slack for this alert
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [CRITICAL] GPD Message API 5xx Error Rate > 10%"
    }

    # 🚨 GPD Message API 499 Error
    rtp_gpd_message_499_alert = {
      name           = "rtp-gpd-message-499-alert"
      description    = "Alert when the GPD Message API returns a 499 (Client Closed Request) error code"
      severity       = 1
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 499
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [WARNING] GPD Message API 499 Client Closed Request Error"
    }

    # 🚨 GPD Message API 502 Error
    rtp_gpd_message_502_alert = {
      name           = "rtp-gpd-message-502-alert"
      description    = "Alert when the GPD Message API returns a 502 (Bad Gateway) error code"
      severity       = 0
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 502
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [CRITICAL] GPD Message API 502 Bad Gateway Error"
    }

    # 🚨 GPD Message API 503 Error
    rtp_gpd_message_503_alert = {
      name           = "rtp-gpd-message-503-alert"
      description    = "Alert when the GPD Message API returns a 503 (Service Unavailable) error code"
      severity       = 0
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 503
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [CRITICAL] GPD Message API 503 Service Unavailable Error"
    }

    # 🚨 GPD Message API 504 Error
    rtp_gpd_message_504_alert = {
      name           = "rtp-gpd-message-504-alert"
      description    = "Alert when the GPD Message API returns a 504 (Gateway Timeout) error code"
      severity       = 0
      frequency      = 120
      time_window    = 120
      data_source_id = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.id
      location       = data.azurerm_log_analytics_workspace.core_log_analytics_workspace.location
      query          = <<-QUERY
            AzureDiagnostics
            | where requestUri_s contains "rtp/gpd/message"
            | where httpMethod_s == "POST"
            | where toint(httpStatus_d) == 504
          QUERY
      trigger = {
        operator  = "GreaterThanOrEqual"
        threshold = 1
      }
      action_groups = compact([
        try(azurerm_monitor_action_group.email[0].id, null),
        try(azurerm_monitor_action_group.slack[0].id, null)
      ])
      email_subject = "[RTP-SENDER] [CRITICAL] GPD Message API 504 Gateway Timeout Error"
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
