prefix                = "cstar"
env_short             = "d"
env                   = "dev"
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
dns_zone_internal_prefix = "internal.dev"
external_domain          = "pagopa.it"

#
# Monitoring
#
monitoring_law_sku               = "PerGB2018"
monitoring_law_retention_in_days = 30
monitoring_law_daily_quota_gb    = 10

### Synthetic
synthetic_storage_account_replication_type = "LRS"
synthetic_alerts_enabled                   = false

synthetic_domain_tae_enabled    = true
synthetic_domain_idpay_enabled  = true
synthetic_domain_shared_enabled = true
synthetic_domain_mc_enabled     = true

### ArgoCD
argocd_helm_release_version    = "8.3.7" #ArgoCD 3.1.5+
argocd_application_namespaces  = ["argocd", "idpay", "keda"]
argocd_force_reinstall_version = "v20250918_1"
ingress_load_balancer_ip       = "10.10.1.250"
