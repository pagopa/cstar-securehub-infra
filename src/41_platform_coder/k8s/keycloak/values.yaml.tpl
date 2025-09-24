forceDeployVersion: ${force_deploy_version}

production: true
proxy: "edge"

global:
  security:
    allowInsecureImages: true

image:
  registry: ${image_registry}
  repository: ${image_repository}
  tag: ${image_tag}

auth:
  adminUser: "${keycloak_admin_username}"
  existingSecret: "keycloak-admin-secret" #keycloak admin password is in this secret

extraEnvVarsCM: "keycloak-config"

initContainers:
  - name: agent-downloader
    image: curlimages/curl:latest
    command: ["curl", "-L", "-o", "/opt/bitnami/keycloak/agent/applicationinsights-agent.jar", "https://github.com/microsoft/ApplicationInsights-Java/releases/download/3.7.4/applicationinsights-agent-3.7.4.jar"]
    volumeMounts:
      - name: agent
        mountPath: "/opt/bitnami/keycloak/agent"

resources:
  requests:
    memory: "1Gi"
    cpu: "1"
  limits:
    memory: "2Gi"
    cpu: "4"

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
  - name: KEYCLOAK_HOSTNAME
    value: ${keycloak_external_hostname}
  - name: KEYCLOAK_HOSTNAME_BACKCHANNEL_DYNAMIC
    value: "true"
  - name: KEYCLOAK_HOSTNAME_ADMIN
    value: "https://${keycloak_ingress_hostname}"
  - name: KC_METRICS_ENABLED
    value: "true"
  - name: KC_TRACING_ENABLED
    value: "true"
    # suppress noisy logs from opentelemetry exporter - the export is handled by the app insights java agent
  - name: KC_LOG_LEVEL_IO_QUARKUS_OPENTELEMETRY_RUNTIME_EXPORTER_OTLP
    value: "ERROR"
  - name: APPLICATIONINSIGHTS_CONNECTION_STRING
    value: "${appinsights_connection_string}"
  - name: KC_SPI_CONNECTIONS_HTTP_CLIENT_DEFAULT_CONNECTION_TTL_MILLIS
    value: "${keycloak_http_client_connection_ttl_millis}"
  - name: KC_SPI_CONNECTIONS_HTTP_CLIENT_DEFAULT_MAX_CONNECTION_IDLE_TIME_MILLIS
    value: "${keycloak_http_client_connection_max_idle_millis}"
  - name: JAVA_OPTS
    value: "-javaagent:/opt/bitnami/keycloak/agent/applicationinsights-agent.jar"

extraVolumes:
  - name: pagopa-theme
    configMap:
      name: keycloak-pagopa-theme
  - name: agent
    emptyDir: {}

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

keycloakConfigCli:
  enabled: true
  existingConfigmap: "keycloak-terraform-client-config"
