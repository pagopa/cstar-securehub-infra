prefix                = "cstar"
env_short             = "u"
env                   = "uat"
location              = "italynorth"
location_display_name = "Italy North"
location_short        = "itn"
domain                = "platform"

#
# Networking
#
### 10.99.4.0/24
cidr_subnet_synthetic_cae = ["10.99.4.0/24"]
### 10.99.5.0/24
cidr_subnet_storage_private_endpoints       = ["10.99.5.0/27"]
cidr_subnet_container_app_private_endpoints = ["10.99.5.32/27"]

#
# Dns
#
dns_zone_internal_prefix = "internal.uat"
external_domain          = "pagopa.it"

#
# Monitoring
#
monitoring_law_sku               = "PerGB2018"
monitoring_law_retention_in_days = 30
monitoring_law_daily_quota_gb    = 10


## Synthetic
synthetic_storage_account_replication_type = "ZRS"
synthetic_alerts_enabled                   = false

synthetic_domain_tae_enabled    = true
synthetic_domain_idpay_enabled  = true
synthetic_domain_shared_enabled = true
synthetic_domain_mc_enabled     = true

### ArgoCD
argocd_helm_release_version    = "8.3.7" #ArgoCD 3.1.5+
argocd_application_namespaces  = ["argocd", "idpay", "keda", "srtp", "mdc"]
argocd_force_reinstall_version = "v20250914_1"
ingress_load_balancer_ip       = "10.10.1.250"
argocd_terraform_module_tier   = "dev"

# Data Explorer
data_explorer_config = {
  enabled = true
  sku = {
    name     = "Dev(No SLA)_Standard_E2a_v4"
    capacity = 1
  }
  autoscale = {
    enabled       = false
    min_instances = 2
    max_instances = 3
  }
  public_network_access_enabled = false
  double_encryption_enabled     = false
  disk_encryption_enabled       = true
  purge_enabled                 = false
}
