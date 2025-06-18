replicaCount: ${replica_count}
auth:
  adminUser: "admin"
  existingSecret: "keycloak-admin-secret"
extraEnvVarsCM: "keycloak-config"
postgresql:
  enabled: true
  auth:
    username: "bn_keycloak"
    database: "bitnami_keycloak"
    existingSecret: "keycloak-db-secret"
  primary:
    persistence:
      enabled: true
      size: 8Gi
ingress:
  enabled: true
  hostname: keycloak.${env}.example.com
  ingressClassName: "nginx"
  tls: true
  extraTls:
    - hosts:
        - keycloak.${env}.example.com
      secretName: ${tls_secret_name}
autoscaling:
  enabled: true
  minReplicas: ${replica_count}
  maxReplicas: 5
  targetCPUUtilizationPercentage: 60
resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "2"
service:
  type: ClusterIP
  ports:
    http: 8080
    https: 8443
rbac:
  create: true
networkPolicy:
  enabled: false
