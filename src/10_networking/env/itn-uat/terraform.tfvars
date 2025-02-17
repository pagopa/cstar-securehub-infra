prefix         = "cstar"
env_short      = "u"
env            = "uat"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "CSTAR"
  Source      = "https://github.com/pagopa/cstar-securehub-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# VNET HUB + SUBNETS
#
cidr_core_hub_vnet = ["10.99.0.0/16"] # 10.99.0.0 --> 10.99.255.255
cidr_subnet_azdoa  = ["10.99.1.0/24"] # 10.99.11.0 --> 10.99.11.255

#
# VNET SPOKES + SUBNETS
#
cidr_spoke_platform_core_vnet = ["10.90.0.0/16"] # 10.90.0.0 --> 10.90.255.255
cidr_subnet_synthetic         = ["10.90.0.0/24"] # 10.99.0.0 --> 10.99.0.255 #placeholder

# cidr_vpn_subnet                  = ["10.1.128.0/24"]   # 10.1.128.0 --> 10.1.128.255
# cidr_subnet_apim                 = ["10.1.129.0/26"]   # 10.1.129.0 --> 10.1.129.63
# cidr_subnet_prv_endpoint         = ["10.1.129.192/26"] # 10.1.129.192 - 10.1.129.255
# cidr_subnet_appgateway           = ["10.1.130.0/24"]   # 10.1.130.0 --> 10.1.130.255
# cidr_subnet_platform_placeholder = ["10.1.131.0/24"]   # 10.1.131.0 --> PLACEHOLDER 10.1.130.255
# cidr_subnet_payhub = ["10.1.163.0/24"] # 10.1.163.0 --> 10.1.163.255 Subnet is linked to the payhub domain
# cidr_subnet_redis = ["10.1.163.0/26"] Variable not used in 01_networking. Subnet created in domains/payhub-common
# cidr_subnet_flex_dbms = ["10.1.163.64/27"] Variable not used in 01_networking. Subnet created in domains/payhub-common
# cidr_subnet_eventhub = ["10.1.163.96/28"] Variable not used in 01_networking. Subnet created in domains/payhub-common

dns_forwarder_vm_image_version = "v1"

#
# DNS
#

external_domain          = "pagopa.it"
dns_zone_prefix          = "uat.cstar"
dns_zone_internal_prefix = "internal.uat.cstar"
