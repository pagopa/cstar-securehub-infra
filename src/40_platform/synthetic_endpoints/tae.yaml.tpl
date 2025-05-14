#
# RTD
#
- apiName: actuator
  appName: rtdmsfileregister
  url: "https://${env_name}01.rtd.${internal_private_domain_suffix}/rtdmsfileregister/actuator/health/liveness"
  type: aks
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
  url: "https://${env_name}01.rtd.${internal_private_domain_suffix}/rtdmsfilereporter/actuator/health/liveness"
  type: aks
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
  url: "https://${env_name}01.rtd.${internal_private_domain_suffix}/rtdmssenderauth/actuator/health/liveness"
  type: aks
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
