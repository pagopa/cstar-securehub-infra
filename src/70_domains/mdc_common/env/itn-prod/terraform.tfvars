prefix         = "cstar"
env_short      = "p"
env            = "prod"
domain         = "mdc"
location       = "italynorth"
location_short = "itn"

# 🔎 DNS
external_domain          = "pagopa.it"
dns_zone_internal_prefix = "internal.cstar"

redis_idh_tier = "standard_C1_v6"

#Monitoring
law_sku               = "PerGB2018"
law_retention_in_days = 30
law_daily_quota_gb    = 100

aks_nodepool = {
  vm_sku_name       = "Standard_D8ads_v5_active"
  autoscale_enabled = true
  node_count_min    = 3
  node_count_max    = 5
}

enable_cosmos_db_weu = true

cosmos_mongodb_params_weu = {
  kind         = "MongoDB"
  capabilities = ["EnableMongo", "DisableRateLimitingResponses"]
  offer_type   = "Standard"
  consistency_policy = {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }
  server_version                   = "6.0"
  main_geo_location_zone_redundant = false
  enable_free_tier                 = false

  additional_geo_locations = [{
    location          = "germanywestcentral"
    failover_priority = 1
    zone_redundant    = false
  }]
  private_endpoint_enabled                     = true
  public_network_access_enabled                = false
  is_virtual_network_filter_enabled            = false
  backup_continuous_enabled                    = true
  enable_provisioned_throughput_exceeded_alert = true
  ip_range_filter = [
    "104.42.195.92", "40.76.54.131", "52.176.6.30", "52.169.50.45",
    "52.187.184.26", "13.88.56.148", "40.91.218.243", "13.91.105.215",
    "4.210.172.107", "40.80.152.199", "13.95.130.121", "20.245.81.54", "40.118.23.126"
  ]
}

cosmos_mongodb_common_configuration = {
  max_throughput    = 10000
  autoscale_enabled = true
}
