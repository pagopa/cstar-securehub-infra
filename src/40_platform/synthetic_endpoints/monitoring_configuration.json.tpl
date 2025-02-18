[
  {
    "apiName" : "api-mcshared",
    "appName" : "mcshared",
    "url" : "https://api-mcshared.dev.cstar.pagopa.it",
    "type" : "appgw",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "tags" : {
      "description" : "cstar mcshared ${env_name} status endpoint"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  }
]
