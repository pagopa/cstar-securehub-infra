image:
  repository: "${image_repository}"
  tag: "${image_tag}"

replicaCount: ${replica_count}

listmonk:
  admin:
    username: "admin"
    existingSecret: "listmonk-bootstrap"
    existingSecretPasswordKey: "LISTMONK_ADMIN_PASSWORD"

setup:
  resources:
    requests:
      cpu: 100m
      memory: 128Mi
    limits:
      cpu: "1"
      memory: 256Mi
  waitImage: "${bootstrap_postgres_image}"

postgresql:
  enabled: false

database:
  mode: external
  external:
    host: "${postgres_db_host}"
    port: ${postgres_db_port}
    name: "${postgres_db_name}"
    username: "${postgres_db_username}"
    existingSecret: "listmonk-db-secret"
    existingSecretPasswordKey: "db_password"
    sslMode: "${postgres_ssl_mode}"

ingress:
  enabled: true
  ingressClassName: "nginx"
  annotations:
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  hosts:
    - host: "${listmonk_ingress_hostname}"
      paths:
        - path: /
          pathType: Prefix
  tls:
    - hosts:
        - "${listmonk_ingress_hostname}"
      secretName: "${ingress_tls_secret_name}"

storage:
  size: 5Gi
  annotations:
    argocd.argoproj.io/sync-options: Prune=false,Delete=false

nodeSelector:
  domain: keycloak

tolerations:
  - key: "keycloakOnly"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: "1"
    memory: 512Mi
