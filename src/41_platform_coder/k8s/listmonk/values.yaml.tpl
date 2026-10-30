ingress:
  enabled: true
  className: "nginx"
  host: "${listmonk_ingress_hostname}"
  annotations: {}
  tls:
    - hosts:
        - "${listmonk_ingress_hostname}"
      secretName: "${ingress_tls_secret_name}"

listmonk:
  image:
    repository: "${image_repository}"
    tag: "${image_tag}"
  replicas: ${replica_count}

postgres:
  enabled: false
  database: "${postgres_db_name}"
  existingSecret: "listmonk-db-secret"
  existingSecretUsernameKey: "db_user"
  existingSecretPasswordKey: "db_password"
  hostname: "${postgres_db_host}"
  port: ${postgres_db_port}
  ssl_mode: "${postgres_ssl_mode}"
