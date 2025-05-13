prefix         = "cstar"
env_short      = "d"
env            = "dev"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "DEV"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

default_zones               = [1]
nat_idle_timeout_in_minutes = 4

#
# VNET
#

cidr_core_hub_vnet = ["10.99.0.0/16"] # 10.99.0.0 --> 10.99.255.255
cidr_subnet_azdoa  = ["10.99.1.0/24"] # 10.99.11.0 --> 10.99.11.255

cidr_subnet_vpn = ["10.99.2.0/24"]

# 📌place holder -> cird_dns_forwarder =  10.9.3.0/24
cidr_subnet_dnsforwarder_lb   = ["10.99.3.0/29"] #10.99.3.0 --> 10.99.3.7
cidr_subnet_dnsforwarder_vmss = ["10.99.3.8/29"] #10.99.3.8 --> 10.99.3.15

#
# VNET SPOKES + SUBNETS
#
cidr_spoke_compute_vnet = ["10.10.0.0/16"] # 10.10.0.0 --> 10.10.255.255

### Data
cidr_spoke_data_vnet         = ["10.20.0.0/16"]  # 10.20.0.0 --> 10.20.255.255
cidr_spoke_data_idpay_domain = ["10.20.10.0/24"] # 📌placeholder 10.20.10.0 --> 10.20.10.255

cidr_spoke_security_vnet = ["10.30.0.0/16"] # 10.30.0.0 --> 10.30.255.255

cidr_spoke_platform_core_vnet = ["10.90.0.0/16"] # 10.90.0.0 --> 10.90.255.255

cidr_subnet_platform_synthetic_cae     = ["10.90.0.0/24"] # 10.99.0.0 --> 10.99.0.255 #📌placeholder for container app
cidr_subnet_platform_private_endpoints = ["10.90.1.0/24"] # 10.99.1.0 --> 10.99.1.255 #📌placeholder

cidr_subnet_data_monitor_workspace = ["10.20.1.0/24"] # 10.20.1.0 --> 10.20.1.255

#
# VPN
#
vpn_sku     = "VpnGw1"
vpn_pip_sku = "Standard"

dns_forwarder_vmss_image_version = "v20250212"

#
# DNS
#

external_domain          = "pagopa.it"
dns_zone_prefix          = "dev.cstar"
dns_zone_internal_prefix = "internal.dev.cstar"
