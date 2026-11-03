<!-- markdownlint-disable -->

## Listmonk

Listmonk is enabled in DEV, UAT, and PROD using the community
[HelmForge chart](https://github.com/helmforgedev/charts/tree/main/charts/listmonk)
at version `1.2.3`, with the application image independently pinned to `v6.2.0`.
It runs in the dedicated `listmonk` namespace on the existing Keycloak node
pool. Uploaded media uses a 5 GiB persistent volume; PostgreSQL is external.
The chart's Deployment is post-rendered with `kubectl kustomize` to use
`Recreate`: this prevents overlapping campaign processors and read-write-once
volume attachment conflicts during rollouts. Terraform runners therefore need
`kubectl` with Kustomize support on their `PATH`.

### PostgreSQL

The `listmonk` database is created on `module.keycloak_pgflex`, the same
`${project}-keycloak-pgflex` server used by Keycloak (in DEV:
`cstar-d-itn-platform-keycloak-pgflex`). No additional server is provisioned.
The PostgreSQL provider connects as the existing administrator over TLS to
create a dedicated `listmonk` login with no elevated privileges or role
memberships. That login receives `CONNECT`/`TEMPORARY` on the new database
and `USAGE`/`CREATE` on its `public` schema; application-created objects belong
to it so installation and subsequent migrations use the same role.
`pgcrypto` is added to the server's extension allowlist and installed in
the new database by the administrator before Listmonk starts.

Credentials are stored as `listmonk-db-user` and `listmonk-db-password` in the
core Key Vault and copied into the namespace's `listmonk-db-secret`.
The PostgreSQL provider's write-only password version follows the Key Vault
secret version so credential changes also update the login.

**Isolation limitation:** existing database permissions are intentionally
unchanged. Only the new database and its schema have their default `PUBLIC`
privileges revoked. There are no explicit Listmonk grants to Keycloak or
other databases, but any existing `PUBLIC` privileges still apply, including
`CONNECT`, `TEMPORARY`, or schema privileges where present. PostgreSQL also
exposes database names through shared catalogs. Strict cross-database
connection isolation requires separately reviewing and revoking `PUBLIC`
access on those existing databases; `NOINHERIT` does not remove `PUBLIC`
privileges.

### Network and TLS

Like Keycloak, Listmonk uses the internal NGINX ingress at `10.10.1.250`,
a private DNS A record, and a certificate mounted from the core Key Vault
through its own Azure workload identity. Endpoints are:

| Environment | URL |
|-------------|-----|
| DEV | `https://listmonk.itn.internal.dev.cstar.pagopa.it` |
| UAT | `https://listmonk.itn.internal.uat.cstar.pagopa.it` |
| PROD | `https://listmonk.itn.internal.cstar.pagopa.it` |

Before applying, provision the matching certificate in the environment's core
Key Vault, using the hostname with dots replaced by hyphens as its name
(for example, `listmonk-itn-internal-dev-cstar-pagopa-it`), as for Keycloak.
The certificate mounter syncs it into a TLS Secret with the same name.
The `listmonk-url` secret is also stored in the core Key Vault.

### Microsoft Entra SSO

SSO uses Listmonk's native OIDC support, directly against the current Azure
tenant. Missing Entra configuration is deliberately left as placeholders in
each environment's `listmonk_sso` block; SSO is disabled until those values
are supplied.

1. Register an Entra web application for Listmonk in each environment. Use the
   corresponding `https://<listmonk-hostname>/auth/oidc` redirect URI and
   configure the `openid`, `profile`, and `email` scopes. Ensure the ID token
   includes an email claim. Restrict enterprise application assignments to
   the intended users/groups.
2. Store its client secret in the core Key Vault as
   `listmonk-azure-app-secret-value`, using the existing encrypted-secret
   workflow. Do not put secret values in tfvars.
3. Fill in `listmonk_sso.client_id`, confirm `client_secret_name`, and set
   `enabled = true`. The issuer is
   `https://login.microsoftonline.com/<current-tenant-id>/v2.0`.
4. By default, SSO only permits users already provisioned in Listmonk with a
   matching email address. To auto-create users, first create a suitable
   least-privilege Listmonk user role, then explicitly set
   `auto_create_users = true` and its `default_user_role_id`. Role `1` is
   Super Admin and should not be used as a general default.

A versioned Kubernetes bootstrap Job installs/upgrades the application schema
idempotently, creates the initial `admin` account using the generated
`listmonk-admin-password` core Key Vault secret, then writes `app.root_url`
and `security.oidc` into Listmonk's settings table. These settings are
database-backed: Helm values or environment variables alone cannot override
them. Terraform owns these two settings; changing them in the UI is not
persistent across a later bootstrap run. The job completes before the chart
starts, and its checksum triggers a pod rollout when configuration changes.
The generated admin password is an initial/bootstrap credential, not an
automatic password reset for an already-installed database.

The bootstrap administrator remains available while Entra placeholders are
incomplete. SMTP configuration and SSO user provisioning are completed in
the Listmonk admin UI.

### Applying and migrating the PoC

Run Terraform from this root with the usual wrapper, for example
`./terraform.sh plan itn-dev`. Both the PostgreSQL provider and Kubernetes
bootstrap need private connectivity to the existing PostgreSQL/AKS endpoints.
Review each environment's plan before applying.
For later application image/schema upgrades, schedule a maintenance window
and stop the existing Listmonk workload before applying: the bootstrap Job
migrates the database before Helm starts the new application version.

If the earlier PoC was applied, stop its Listmonk workload before migrating:
the namespace changes from `idpay` to `listmonk`, the hostname changes from
`idpay.*` to `listmonk.*`, the chart changes, and the URL secret moves from
the IDPay Key Vault to the core Key Vault. Back up the database and copy any
existing uploaded media to the new PVC. If the `listmonk` database already
exists outside Terraform, import it into
`azurerm_postgresql_flexible_server_database.listmonk_db` rather than
recreating it. Existing application objects must be reassigned to the new
`listmonk` role under an explicit, reviewed migration before bootstrap runs;
schema grants do not transfer ownership of existing tables, sequences, or
types. Preserve any existing admin credentials as well.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.11.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.32.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2 |
| <a name="requirement_keycloak"></a> [keycloak](#requirement\_keycloak) | ~> 5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_postgresql"></a> [postgresql](#requirement\_postgresql) | ~> 1.26.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.32.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_keycloak"></a> [keycloak](#provider\_keycloak) | 5.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_postgresql"></a> [postgresql](#provider\_postgresql) | 1.26.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

| Name | Source | Version |
| ---- | ------ | ------- |
| <a name="module___v4__"></a> [\_\_v4\_\_](#module\_\_\_v4\_\_) | git::https://github.com/pagopa/terraform-azurerm-v4.git | 7e5635fc04118ced0abbf7089611b4178d447322 |
| <a name="module_aks_user_foobar_node_pool_keycloak"></a> [aks\_user\_foobar\_node\_pool\_keycloak](#module\_aks\_user\_foobar\_node\_pool\_keycloak) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_aks_user_keycloak_snet"></a> [aks\_user\_keycloak\_snet](#module\_aks\_user\_keycloak\_snet) | ./.terraform/modules/__v4__/IDH/subnet | n/a |
| <a name="module_aks_user_node_pool_keycloak"></a> [aks\_user\_node\_pool\_keycloak](#module\_aks\_user\_node\_pool\_keycloak) | ./.terraform/modules/__v4__/IDH/aks_node_pool | n/a |
| <a name="module_cert_mounter"></a> [cert\_mounter](#module\_cert\_mounter) | ./.terraform/modules/__v4__/cert_mounter | n/a |
| <a name="module_core_secrets"></a> [core\_secrets](#module\_core\_secrets) | ./.terraform/modules/__v4__/key_vault_secrets_query | n/a |
| <a name="module_keycloak_pgflex"></a> [keycloak\_pgflex](#module\_keycloak\_pgflex) | ./.terraform/modules/__v4__/IDH/postgres_flexible_server | n/a |
| <a name="module_listmonk_cert_mounter"></a> [listmonk\_cert\_mounter](#module\_listmonk\_cert\_mounter) | ./.terraform/modules/__v4__/cert_mounter | n/a |
| <a name="module_tag_config"></a> [tag\_config](#module\_tag\_config) | ../tag_config | n/a |
| <a name="module_workload_identity_configuration_platform_coder_keycloak"></a> [workload\_identity\_configuration\_platform\_coder\_keycloak](#module\_workload\_identity\_configuration\_platform\_coder\_keycloak) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_workload_identity_configuration_platform_coder_listmonk"></a> [workload\_identity\_configuration\_platform\_coder\_listmonk](#module\_workload\_identity\_configuration\_platform\_coder\_listmonk) | ./.terraform/modules/__v4__/kubernetes_workload_identity_configuration | n/a |
| <a name="module_workload_identity_platform_coder"></a> [workload\_identity\_platform\_coder](#module\_workload\_identity\_platform\_coder) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |
| <a name="module_workload_identity_platform_coder_listmonk"></a> [workload\_identity\_platform\_coder\_listmonk](#module\_workload\_identity\_platform\_coder\_listmonk) | ./.terraform/modules/__v4__/kubernetes_workload_identity_init | n/a |

## Resources

| Name | Type |
| ---- | ---- |
| [azurerm_key_vault_secret.keycloak_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_db_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_db_admin_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.keycloak_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.listmonk_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.listmonk_db_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.listmonk_db_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.listmonk_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.terraform_client_secret_for_keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_postgresql_flexible_server_database.keycloak_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_postgresql_flexible_server_database.listmonk_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server_database) | resource |
| [azurerm_private_dns_a_record.keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.listmonk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_subnet_nat_gateway_association.nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |
| [helm_release.keycloak](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.listmonk](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.reloader](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [keycloak_custom_identity_provider_mapper.azure_admin_mapper_master](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.azure_email](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.azure_first_name](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.azure_last_name](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_custom_identity_provider_mapper.azure_username_mapper](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/custom_identity_provider_mapper) | resource |
| [keycloak_oidc_identity_provider.master_admin](https://registry.terraform.io/providers/keycloak/keycloak/latest/docs/resources/oidc_identity_provider) | resource |
| [kubernetes_config_map.keycloak-terraform-client-config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_config](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_mdc_portal_theme](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_pagopa_theme](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.keycloak_providers](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.listmonk_bootstrap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_job_v1.listmonk_bootstrap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/job_v1) | resource |
| [kubernetes_namespace.keycloak](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.listmonk](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.keycloak_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.keycloak_db](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.listmonk_bootstrap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.listmonk_db](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [postgresql_extension.listmonk_pgcrypto](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/extension) | resource |
| [postgresql_grant.listmonk_database](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.listmonk_public_database](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.listmonk_public_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_grant.listmonk_schema](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/grant) | resource |
| [postgresql_role.listmonk](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/role) | resource |
| [random_password.keycloak_admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.keycloak_db_admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.listmonk_admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.listmonk_db](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.terraform_client_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azuread_application.keycloak](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) | data source |
| [azuread_group.adgroup_admin](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_developers](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_externals](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.adgroup_security](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azurerm_application_insights.app_insights_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.key_vault_core](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.keycloak_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.listmonk_oidc_client_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.terraform_client_secret_for_keycloak](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) | data source |
| [azurerm_kubernetes_cluster.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/kubernetes_cluster) | data source |
| [azurerm_log_analytics_workspace.logs_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_nat_gateway.compute_nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/nat_gateway) | data source |
| [azurerm_private_dns_zone.internal](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_private_dns_zone.postgres_flexible_privatelink](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_resource_group.core_monitor_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.monitoring_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_resource_group.platform_data](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.platform_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [azurerm_virtual_network.data_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aks_user_foobar_node_pool_keycloak"></a> [aks\_user\_foobar\_node\_pool\_keycloak](#input\_aks\_user\_foobar\_node\_pool\_keycloak) | n/a | <pre>object({<br/>    enabled           = optional(bool, true)<br/>    idh_resource_tier = string<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>    os_disk_size_gb   = optional(number, null)<br/>    os_disk_type      = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_aks_user_node_pool_keycloak"></a> [aks\_user\_node\_pool\_keycloak](#input\_aks\_user\_node\_pool\_keycloak) | n/a | <pre>object({<br/>    enabled           = optional(bool, true)<br/>    idh_resource_tier = string<br/>    node_count_min    = number<br/>    node_count_max    = number<br/>    os_disk_size_gb   = optional(number, null)<br/>    os_disk_type      = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment | `string` | n/a | yes |
| <a name="input_env_short"></a> [env\_short](#input\_env\_short) | n/a | `string` | n/a | yes |
| <a name="input_external_domain"></a> [external\_domain](#input\_external\_domain) | Domain for delegation | `string` | n/a | yes |
| <a name="input_keycloak_configuration"></a> [keycloak\_configuration](#input\_keycloak\_configuration) | n/a | <pre>object({<br/>    image_repository                            = string<br/>    image_tag                                   = string<br/>    image_registry                              = string<br/>    chart_version                               = string<br/>    replica_count_min                           = number<br/>    replica_count_max                           = number<br/>    cpu_request                                 = string<br/>    cpu_limit                                   = string<br/>    memory_request                              = string<br/>    memory_limit                                = string<br/>    http_client_connection_ttl_millis           = number<br/>    http_client_connection_max_idle_time_millis = number<br/>    image_registry_config_cli                   = string<br/>    image_repository_config_cli                 = string<br/>    image_tag_config_cli                        = string<br/>    image_digest_config_cli                     = optional(string, "")<br/>  })</pre> | n/a | yes |
| <a name="input_keycloak_pgflex_params"></a> [keycloak\_pgflex\_params](#input\_keycloak\_pgflex\_params) | Postgres Flexible | <pre>object({<br/>    enabled                                = bool<br/>    zone                                   = number<br/>    idh_resource_tier                      = string<br/>    geo_replication_enabled                = bool<br/>    pgres_flex_pgbouncer_enabled           = bool<br/>    pgres_flex_diagnostic_settings_enabled = bool<br/>    auto_grow_enabled                      = bool<br/>    storage_tier                           = optional(string, null)<br/>  })</pre> | n/a | yes |
| <a name="input_listmonk_configuration"></a> [listmonk\_configuration](#input\_listmonk\_configuration) | n/a | <pre>object({<br/>    chart_version            = string<br/>    image_repository         = string<br/>    image_tag                = string<br/>    replica_count            = number<br/>    postgres_ssl_mode        = string<br/>    bootstrap_postgres_image = optional(string, "postgres:17-alpine")<br/>  })</pre> | n/a | yes |
| <a name="input_listmonk_sso"></a> [listmonk\_sso](#input\_listmonk\_sso) | Native Microsoft Entra OIDC. Enable after registering the app and storing its client secret in the core Key Vault. | <pre>object({<br/>    enabled              = bool<br/>    client_id            = string<br/>    client_secret_name   = string<br/>    auto_create_users    = optional(bool, false)<br/>    default_user_role_id = optional(number)<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_location_short"></a> [location\_short](#input\_location\_short) | Location short like eg: neu, weu.. | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_dns_zone_internal_prefix"></a> [dns\_zone\_internal\_prefix](#input\_dns\_zone\_internal\_prefix) | The dns subdomain. | `string` | `""` | no |
| <a name="input_k8s_kube_config_path_prefix"></a> [k8s\_kube\_config\_path\_prefix](#input\_k8s\_kube\_config\_path\_prefix) | Kubernetes | `string` | `"~/.kube"` | no |
| <a name="input_mcshared_dns_zone_prefix"></a> [mcshared\_dns\_zone\_prefix](#input\_mcshared\_dns\_zone\_prefix) | The dns subdomain for mcshared | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
