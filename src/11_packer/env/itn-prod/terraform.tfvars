prefix         = "cstar"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

azdo_agent_image_version    = "v20250519" #v5.11.0
dns_forwarder_image_version = "v20250519" #v5.11.0
