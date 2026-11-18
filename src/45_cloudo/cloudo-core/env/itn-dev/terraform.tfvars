prefix               = "cstar"
env_short            = "d"
env                  = "dev"
location_short_ita   = "itn"
cloudo_function_tier = "basic_private"
cloudo_ui_tier       = "basic"

### External resources
application_insisght_name                = "cstar-d-appinsights"
application_insisght_resource_group_name = "cstar-d-monitor-rg"

# ClouDO orchestrator parameters
cloudo_orchestrator = {
  image_name        = "pagopa/cloudo-orchestrator"
  image_tag         = "0.0.0"
  registry_url      = "https://ghcr.io"
  registry_username = "payments-cloud-bot"
}

# ClouDO UI parameters
cloudo_ui = {
  image_name        = "pagopa/cloudo-ui"
  image_tag         = "0.0.0"
  registry_url      = "https://ghcr.io"
  registry_username = "payments-cloud-bot"
}

# ClouDO worker parameters
cloudo_worker = {
  image_name        = "pagopa/cloudo-worker"
  image_tag         = "0.0.0"
  registry_url      = "https://ghcr.io"
  registry_username = "payments-cloud-bot"
}

# ClouDO agent parameters
cloudo_agent = {
  image_name        = "pagopa/cloudo-agent"
  image_tag         = "0.0.0"
  registry_url      = "https://ghcr.io"
  registry_username = "payments-cloud-bot"
}
