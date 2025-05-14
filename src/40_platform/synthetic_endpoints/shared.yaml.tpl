#- apiName: api_mcshared
#  appName: mcshared_appgw
#  url: "https://api-mcshared.${public_hostname}"
#  type: appgw
#  checkCertificate: true
#  method: GET
#  expectedCodes: ["200"]
#  tags:
#    description: "cstar mcshared ${env_name} status endpoint"
#  durationLimit: 10000
#  alertConfiguration:
#    enabled: ${alert_enabled}
#  enabled: ${shared_enabled}
