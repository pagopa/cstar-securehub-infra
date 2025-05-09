prefix         = "cstar"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

default_zones               = [1, 2, 3]
nat_idle_timeout_in_minutes = 4

#
# VNET
#

cidr_core_hub_vnet = ["10.99.0.0/16"] # 10.99.0.0 --> 10.99.255.255
cidr_subnet_azdoa  = ["10.99.1.0/24"] # 10.99.11.0 --> 10.99.11.255

#
# VNET SPOKES + SUBNETS
#
cidr_spoke_compute_vnet = ["10.10.0.0/16"] # 10.10.0.0 --> 10.10.255.255

### Data
cidr_spoke_data_vnet         = ["10.20.0.0/16"]  # 10.20.0.0 --> 10.20.255.255
cidr_spoke_data_idpay_domain = ["10.20.10.0/24"] # placeholder 10.20.10.0 --> 10.20.10.255

cidr_spoke_security_vnet      = ["10.30.0.0/16"] # 10.30.0.0 --> 10.30.255.255
cidr_spoke_platform_core_vnet = ["10.90.0.0/16"] # 10.90.0.0 --> 10.90.255.255

cidr_subnet_platform_synthetic_cae     = ["10.90.0.0/24"] # 10.99.0.0 --> 10.99.0.255 #placeholder for container app
cidr_subnet_platform_private_endpoints = ["10.90.1.0/24"] # 10.99.1.0 --> 10.99.1.255 #placeholder

cidr_subnet_data_monitor_workspace = ["10.20.1.0/24"] # 10.20.1.0 --> 10.20.1.255

#
# VPN
#
dns_forwarder_vm_image_version = "v240924"

#
# DNS
#

external_domain          = "pagopa.it"
dns_zone_prefix          = "cstar"
dns_zone_internal_prefix = "internal.cstar"
