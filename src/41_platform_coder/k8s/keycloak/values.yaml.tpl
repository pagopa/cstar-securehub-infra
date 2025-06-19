forceDeployVersion: ${force_deploy_version}

auth:
  adminUser: "admin"
  existingSecret: "keycloak-admin-secret"

extraEnvVarsCM: "keycloak-config"

resources:
  requests:
    memory: "1Gi"
    cpu: "500m"
  limits:
    memory: "2Gi"
    cpu: "2"

# ------------------------------------------------------
# Database – External Azure PostgreSQL Flexible Server
# ------------------------------------------------------
postgresql:
  enabled: false  # Disables embedded PostgreSQL

externalDatabase:
  host: ${postgres_db_host}
  port: ${postgres_db_port}
  user: ${postgres_db_username}
  database: ${postgres_db_name}
  existingSecret: "keycloak-db-secret"  # Secret with key "password"

# TLS/SSL for DB connection via JDBC parameter
extraEnvVars:
  - name: KC_DB_URL_PROPERTIES
    value: "sslmode=require"

# ------------------------------------------------------
# Ingress (NGINX)
# ------------------------------------------------------
ingress:
  enabled: true
  hostname: ${keycloak_ingress_hostname}
  ingressClassName: "nginx"
  tls: true
  extraTls:
    - hosts:
        - ${keycloak_ingress_hostname}
      secretName: ${ingress_tls_secret_name}

# ------------------------------------------------------
# Autoscaling: CPU & MEMORY
# ------------------------------------------------------
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

# ------------------------------------------------------
# Update strategy & startup probe (Zero Downtime Upgrades)
# ------------------------------------------------------
updateStrategy:
  type: RollingUpdate

startupProbe:
  enabled: true
  initialDelaySeconds: 60
  periodSeconds: 5
  timeoutSeconds: 2
  failureThreshold: 60
  successThreshold: 1

# ------------------------------------------------------
# Pod Disruption Budget (Zero downtime during maintenance)
# ------------------------------------------------------
pdb:
  create: true
  minAvailable: 1

# ------------------------------------------------------
# Topology Spread / Affinity – spread pods across nodes
# ------------------------------------------------------
affinity: {}

topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: kubernetes.io/hostname
    whenUnsatisfiable: ScheduleAnyway
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: keycloak

# ------------------------------------------------------
# Resources & Service
# ------------------------------------------------------
service:
  type: ClusterIP
  ports:
    http: 8080
    https: 8443

rbac:
  create: true
networkPolicy:
  enabled: false
