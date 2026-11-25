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
%{ if smtp_enabled ~}

extraManifests:
  - apiVersion: batch/v1
    kind: Job
    metadata:
      name: listmonk-configure-smtp
      annotations:
        argocd.argoproj.io/hook: PostSync
        argocd.argoproj.io/hook-delete-policy: BeforeHookCreation,HookSucceeded
    spec:
      backoffLimit: 1
      activeDeadlineSeconds: 300
      template:
        spec:
          restartPolicy: Never
          automountServiceAccountToken: false
          nodeSelector:
            domain: keycloak
          tolerations:
            - key: keycloakOnly
              operator: Equal
              value: "true"
              effect: NoSchedule
          securityContext:
            runAsNonRoot: true
            runAsUser: 10001
            seccompProfile:
              type: RuntimeDefault
          containers:
            - name: configure-smtp
              image: python:3.13-alpine
              command: ["python", "-c"]
              args:
                - |
                  ${indent(18, smtp_setup_script)}
              envFrom:
                - secretRef:
                    name: listmonk-smtp
              env:
                - name: LISTMONK_URL
                  value: "https://${listmonk_ingress_hostname}"
                - name: LISTMONK_ADMIN_USERNAME
                  value: admin
                - name: LISTMONK_ADMIN_PASSWORD
                  valueFrom:
                    secretKeyRef:
                      name: listmonk-bootstrap
                      key: LISTMONK_ADMIN_PASSWORD
              resources:
                requests:
                  cpu: 50m
                  memory: 32Mi
                limits:
                  cpu: 250m
                  memory: 128Mi
              securityContext:
                allowPrivilegeEscalation: false
                readOnlyRootFilesystem: true
                capabilities:
                  drop: ["ALL"]
%{ endif ~}
