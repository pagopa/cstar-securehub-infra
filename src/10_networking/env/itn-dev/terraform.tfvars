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

#
# VNET
#

cidr_core_hub_vnet = ["10.99.0.0/16"] # 10.99.0.0 --> 10.99.255.255
cidr_subnet_azdoa = ["10.99.1.0/24"] # 10.99.11.0 --> 10.99.11.255
# cidr_vpn_subnet   = ["10.1.128.0/24"]  # 10.1.128.0 --> 10.1.128.255
# # cidr_subnet_redis = ["10.1.129.128/26"] Variable not used in 01_networking. Subnet created in domains/payhub-common
# cidr_subnet_prv_endpoint         = ["10.1.129.192/26"] # 10.1.129.192 - 10.1.129.255
# cidr_subnet_appgateway           = ["10.1.130.0/24"]   # 10.1.130.0 --> 10.1.130.255
# cidr_subnet_platform_placeholder = ["10.1.131.0/24"]   # 10.1.131.0 --> PLACEHOLDER 10.1.130.255
# # cidr_subnet_flex_dbms = ["10.1.162.0/27"] Variable not used in 01_networking. Subnet created in domains/payhub-common
# # cidr_subnet_eventhub = ["10.1.163.0/28"] Variable not used in 01_networking. Subnet created in domains/payhub-common
# # cidr_subnet_payhub = ["10.1.163.0/24"] # 10.1.163.0 --> 10.1.163.255 Subnet is linked to the payhub domain


dns_forwarder_vm_image_version = "v2"
#
# DNS
#

external_domain          = "pagopa.it"
dns_zone_prefix          = "dev.cstar"
dns_zone_internal_prefix = "internal.dev.cstar"
