namespace: ${NAMESPACE}
nameOverride: ""
fullnameOverride: ""

deployment:
  create: true

kvCertificatesName:
  - ${CERTIFICATE_NAME}

keyvault:
  name: "${KEYVAULT_NAME}"
  tenantId: "7788edaf-0346-4068-9d79-c868aed15b3d"
