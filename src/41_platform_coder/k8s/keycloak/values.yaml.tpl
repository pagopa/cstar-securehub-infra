forceDeployVersion: ${force_deploy_version}

production: true
proxy: "edge"

auth:
  adminUser: "${keycloak_admin_username}"
  existingSecret: "keycloak-admin-secret" #keycloak admin password is in this secret

extraEnvVarsCM: "keycloak-config"

resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "2"

postgresql:
  enabled: false

externalDatabase:
  host: ${postgres_db_host}
  port: ${postgres_db_port}
  user: ${postgres_db_username}
  database: ${postgres_db_name}
  existingSecret: "keycloak-db-secret"

# TLS/SSL per la connessione al DB
extraEnvVars:
  - name: KC_DB_URL_PROPERTIES
    value: "sslmode=require"
# enable this option to import realm on startup. ATM it is disabled because it creates a new realm and the client is not usable by the terraform provider to create new realms
#  - name: KEYCLOAK_EXTRA_ARGS
#    value: "--import-realm"
  - name: KEYCLOAK_HOSTNAME
    value: ${keycloak_external_hostname}
  - name: KEYCLOAK_HOSTNAME_BACKCHANNEL_DYNAMIC
    value: "true"
  - name: KEYCLOAK_HOSTNAME_ADMIN
    value: "https://${keycloak_ingress_hostname}"
  - name: KC_SPI_CONNECTIONS_HTTP_CLIENT__DEFAULT__CONNECTION_TTL_MILLIS
    value: "${keycloak_http_client_connection_ttl_millis}"

extraVolumes:
  - name: realm-import
    configMap:
      name: keycloak-realm-import

  - name: pagopa-theme
    configMap:
      name: keycloak-pagopa-theme

extraVolumeMounts:
${keycloak_extra_volume_mounts}


ingress:
  enabled: true
  hostname: ${keycloak_ingress_hostname}
  ingressClassName: "nginx"
  tls: true
  extraTls:
    - hosts:
        - ${keycloak_ingress_hostname}
      secretName: ${ingress_tls_secret_name}

autoscaling:
  enabled: true
  minReplicas: ${replica_count_min}
  maxReplicas: ${replica_count_max}
  targetCPU: 60
  targetMemory: 70
  behavior:
    scaleUp:
      policies:
        - type: Percent
          value: 100
          periodSeconds: 60

updateStrategy:
  type: RollingUpdate

startupProbe:
  enabled: true
  initialDelaySeconds: 30
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 60
  successThreshold: 1

pdb:
  create: true
  minAvailable: 1

affinity: {}

topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: ScheduleAnyway
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: keycloak

service:
  type: ClusterIP
  ports:
    http: 8080
    https: 8443

rbac:
  create: true
networkPolicy:
  enabled: false
