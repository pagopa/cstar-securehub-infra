- apiName: actuator
  appName: emdtpp
  url: "https://mil.weu.${internal_private_domain_suffix}/emdtpp/actuator/health"
  type: aks
  checkCertificate: true
  method: GET
  expectedCodes: ["200"]
  tags:
    description: "cstar MIL emdtpp ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${mc_enabled}

- apiName: actuator
  appName: emdcitizen
  url: "https://mil.weu.${internal_private_domain_suffix}/emdcitizen/actuator/health"
  type: aks
  checkCertificate: true
  method: GET
  expectedCodes: ["200"]
  tags:
    description: "cstar MIL emdcitizen ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${mc_enabled}

- apiName: actuator
  appName: emdmessagecore
  url: "https://mil.weu.${internal_private_domain_suffix}/emdmessagecore/actuator/health"
  type: aks
  checkCertificate: true
  method: GET
  expectedCodes: ["200"]
  tags:
    description: "cstar MIL emdmessagecore ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${mc_enabled}

- apiName: actuator
  appName: emdnotifiersender
  url: "https://mil.weu.${internal_private_domain_suffix}/emdnotifiersender/actuator/health"
  type: aks
  checkCertificate: true
  method: GET
  expectedCodes: ["200"]
  tags:
    description: "cstar MIL emdnotifiersender ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${mc_enabled}

- apiName: actuator
  appName: emdpaymentcore
  url: "https://mil.weu.${internal_private_domain_suffix}/emdpaymentcore/actuator/health"
  type: aks
  checkCertificate: true
  method: GET
  expectedCodes: ["200"]
  tags:
    description: "cstar MIL emdpaymentcore ${env_name} status endpoint"
  durationLimit: 10000
  alertConfiguration:
    enabled: ${alert_enabled}
  enabled: ${mc_enabled}
