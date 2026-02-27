prefix         = "cstar"
env_short      = "u"
env            = "uat"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.uat.cstar"

# Redis
redis_idh_tier = "basic"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 15

aks_nodepool = {
  vm_sku_name       = "Standard_D4ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 1
  node_count_max    = 2
}

enable_cosmos_db_weu = true

cosmos_mongodb_params_weu = {
  kind         = "MongoDB"
  capabilities = ["EnableMongo", "EnableUniqueCompoundNestedDocs"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100000
  }
  server_version                   = "7.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  additional_geo_locations          = []
  public_network_access_enabled     = false
  is_virtual_network_filter_enabled = false

  backup_continuous_enabled = true
  ip_range_filter           = ["104.42.195.92", "40.76.54.131", "52.176.6.30", "52.169.50.45", "52.187.184.26", "13.88.56.148", "40.91.218.243", "13.91.105.215", "4.210.172.107", "40.80.152.199", "13.95.130.121", "20.245.81.54", "40.118.23.126"]
}

cosmos_mongodb_common_configuration = {
  max_throughput    = 1000
  autoscale_enabled = true
}
