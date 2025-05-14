#
# RTD
#
- apiName: actuator
  appName: rtdmsfileregister
  url: "https://${env_name}01.rtd.${internal_private_hostname}/rtdmsfileregister/actuator/health/liveness"
  type: aks
  domain: tae
  checkCertificate: true
  method: GET
  expectedCodes:
    - "200"
  tags:
    description: "cstar RTD rtdmsfileregister ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${tae_enabled}

- apiName: actuator
  appName: rtdmsfilereporter
  url: "https://${env_name}01.rtd.${internal_private_hostname}/rtdmsfilereporter/actuator/health/liveness"
  type: aks
  domain: tae
  checkCertificate: true
  method: GET
  expectedCodes:
    - "200"
  tags:
    description: "cstar RTD rtdmsfilereporter ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${tae_enabled}

- apiName: actuator
  appName: rtdmssenderauth
  url: "https://${env_name}01.rtd.${internal_private_hostname}/rtdmssenderauth/actuator/health/liveness"
  type: aks
  domain: tae
  checkCertificate: true
  method: GET
  expectedCodes:
    - "200"
  tags:
    description: "cstar RTD rtdmssenderauth ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${tae_enabled}
