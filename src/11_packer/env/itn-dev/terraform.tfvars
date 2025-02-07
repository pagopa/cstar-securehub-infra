prefix         = "p4pa"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "P4PA"
  Source      = "https://github.com/pagopa/p4pa-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

azdo_agent_image_version    = "v20241219"
dns_forwarder_image_version = "v2"