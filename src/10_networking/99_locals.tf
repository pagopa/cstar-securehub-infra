locals {
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.domain}"
  product = "${var.prefix}-${var.env_short}"

  ### 🏷️ Tags
  tags_for_mc = merge(module.tag_config.tags, {
    "domain" = "mc"
  })

  vnets_secure_hub_italy = {
    core_hub = {
      name = module.vnet_core_hub.name
      id   = module.vnet_core_hub.id
    }
    spoke_data = {
      name = module.vnet_spoke_data.name
      id   = module.vnet_spoke_data.id
    }
    spoke_compute = {
      name = module.vnet_spoke_compute.name
      id   = module.vnet_spoke_compute.id
    }
    spoke_security = {
      name = module.vnet_spoke_security.name
      id   = module.vnet_spoke_security.id
    }
  }


  # VNET Legacy
  vnet_weu_core = {
    name           = "${var.prefix}-${var.env_short}-vnet"
    resource_group = "${var.prefix}-${var.env_short}-vnet-rg"
  }

  vnet_weu_integration = {
    name           = "${var.prefix}-${var.env_short}-integration-vnet"
    resource_group = "${var.prefix}-${var.env_short}-vnet-rg"
  }

  vnet_weu_aks = {
    name           = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet"
    resource_group = "${var.prefix}-${var.env_short}-weu-${var.env}01-vnet-rg"
  }

  #
  # KV
  #
  kv_core_name                = "${local.project}-kv"
  kv_core_resource_group_name = "${local.project}-sec-rg"

  #
  # Packer
  #
  packer_rg_name = "${local.product}-${var.location_short}-packer-rg"

  # 🔎 DNS
  dns_public_zones = [
    "bonuselettrodomestici.it",
    "bonuselettrodomestici.com",
    "bonuselettrodomestici.info",
    "bonuselettrodomestici.io",
    "bonuselettrodomestici.net",
    "bonuselettrodomestici.eu"
  ]

  dns_env_public_zones = [
    for i in local.dns_public_zones :
    var.env_short != "p" ? "${var.env}.${i}" : i
  ]

  dev_ns_records = {
    "bonuselettrodomestici.it"   = ["ns1-09.azure-dns.com.", "ns2-09.azure-dns.net.", "ns3-09.azure-dns.org.", "ns4-09.azure-dns.info."]
    "bonuselettrodomestici.com"  = ["ns1-03.azure-dns.com.", "ns2-03.azure-dns.net.", "ns3-03.azure-dns.org.", "ns4-03.azure-dns.info."]
    "bonuselettrodomestici.info" = ["ns1-02.azure-dns.com.", "ns2-02.azure-dns.net.", "ns3-02.azure-dns.org.", "ns4-02.azure-dns.info."]
    "bonuselettrodomestici.io"   = ["ns1-07.azure-dns.com.", "ns2-07.azure-dns.net.", "ns3-07.azure-dns.org.", "ns4-07.azure-dns.info."]
    "bonuselettrodomestici.net"  = ["ns1-07.azure-dns.com.", "ns2-07.azure-dns.net.", "ns3-07.azure-dns.org.", "ns4-07.azure-dns.info."]
    "bonuselettrodomestici.eu"   = ["ns1-01.azure-dns.com.", "ns2-01.azure-dns.net.", "ns3-01.azure-dns.org.", "ns4-01.azure-dns.info."]
  }
  uat_ns_records = {
    "bonuselettrodomestici.it"   = ["ns1-03.azure-dns.com.", "ns2-03.azure-dns.net.", "ns3-03.azure-dns.org.", "ns4-03.azure-dns.info."]
    "bonuselettrodomestici.com"  = ["ns1-03.azure-dns.com.", "ns2-03.azure-dns.net.", "ns3-03.azure-dns.org.", "ns4-03.azure-dns.info."]
    "bonuselettrodomestici.info" = ["ns1-01.azure-dns.com.", "ns2-01.azure-dns.net.", "ns3-01.azure-dns.org.", "ns4-01.azure-dns.info."]
    "bonuselettrodomestici.io"   = ["ns1-01.azure-dns.com.", "ns2-01.azure-dns.net.", "ns3-01.azure-dns.org.", "ns4-01.azure-dns.info."]
    "bonuselettrodomestici.net"  = ["ns1-06.azure-dns.com.", "ns2-06.azure-dns.net.", "ns3-06.azure-dns.org.", "ns4-06.azure-dns.info."]
    "bonuselettrodomestici.eu"   = ["ns1-04.azure-dns.com.", "ns2-04.azure-dns.net.", "ns3-04.azure-dns.org.", "ns4-04.azure-dns.info."]
  }

  dns_default_ttl_sec = 3600
}
