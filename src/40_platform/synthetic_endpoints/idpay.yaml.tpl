#- apiName: actuator
#  appName: idpaypayment
#  url: "https://${env_name}01.idpay.${internal_private_hostname}/idpaypayment/actuator/health"
#  type: aks
#  checkCertificate: true
#  method: GET
#  expectedCodes: ["200"]
#  tags:
#    description: "cstar IDPAY idpaypayment ${env_name} status endpoint"
#  durationLimit: 10000
#  alertConfiguration:
#    enabled: ${alert_enabled}
#  enabled: ${idpay_enabled}
#
#- apiName: actuator
#  appName: idpaywallet
#  url: "https://${env_name}01.idpay.${internal_private_hostname}/idpaywallet/actuator/health"
#  type: aks
#  checkCertificate: true
#  method: GET
#  expectedCodes: ["200"]
#  tags:
#    description: "cstar IDPAY idpaywallet ${env_name} status endpoint"
#  durationLimit: 10000
#  alertConfiguration:
#    enabled: ${alert_enabled}
#  enabled: ${idpay_enabled}
#
#- apiName: actuator
#  appName: idpayportalwelfarebackendinitiative
#  url: "https://${env_name}01.idpay.${internal_private_hostname}/idpayportalwelfarebackendinitiative/actuator/health"
#  type: aks
#  checkCertificate: true
#  method: GET
#  expectedCodes: ["200"]
#  tags:
#    description: "cstar IDPAY idpayportalwelfarebackendinitiative ${env_name} status endpoint"
#  durationLimit: 10000
#  alertConfiguration:
#    enabled: ${alert_enabled}
#  enabled: ${idpay_enabled}
#
#- apiName: actuator
#  appName: idpayreward
#  url: "https://${env_name}01.idpay.${internal_private_hostname}/idpay/reward/actuator/health"
#  type: aks
#  checkCertificate: true
#  method: GET
#  expectedCodes: ["200"]
#  tags:
#    description: "cstar IDPAY idpayreward ${env_name} status endpoint"
#  durationLimit: 10000
#  alertConfiguration:
#    enabled: ${alert_enabled}
#  enabled: ${idpay_enabled}
