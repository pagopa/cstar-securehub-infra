[
  {
    "apiName" : "root",
    "appName" : "arc",
    "url" : "https://${api_domain}/",
    "type" : "apim",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "tags" : {
      "description" : "p4pa ${env_name} context root"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  },
  {
    "apiName" : "root",
    "appName" : "arc",
    "url" : "https://${appgw_public_ip}/",
    "type" : "appgw",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "headers": {
      "Host": "${api_domain}"
    },
    "tags" : {
      "description" : "arc ${env_name} context root"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  },
  {
    "apiName" : "root",
    "appName" : "cittadini",
    "url" : "https://citizen.${internal_suffix_domain}/arcbe/actuator/health/liveness",
    "type" : "aks",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "tags" : {
      "description" : "arc ${env_name} cittadini (arc-be) status endpoint"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  },
  {
    "apiName" : "root",
    "appName" : "cittadini",
    "url" : "https://${api_domain}/health/v1",
    "type" : "apim",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "tags" : {
      "description" : "arc ${env_name} cittadini (arc-be) status endpoint"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  }
]
