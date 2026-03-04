locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  application_owners = [
    "diego.lagosmorales@pagopa.it",
    "matteo.alongi@pagopa.it",
    "marco.mari@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "fabio.felici@pagopa.it"
  ]

  # These groups are allowed to be linked into the projects or global setup of ArgoCD
  # If not present here or in the extra variable, the user can login to ArgoCD but with nothing assigned
  entra_groups_allowed = concat([
    #Global groups
    "${local.product}-adgroup-admin",
    "${local.product}-adgroup-developers",
    "${local.product}-adgroup-externals",
    "${local.product}-adgroup-technical-project-managers",
    #SRTP Groups
    "${local.product}-srtp-adgroup-admin",
    "${local.product}-srtp-adgroup-developers",
    "${local.product}-srtp-adgroup-externals",
    #IDPay Groups
    "${local.product}-idpay-adgroup-admin",
    "${local.product}-idpay-adgroup-developers",
    "${local.product}-idpay-adgroup-externals",
    #MDC Groups
    "${local.product}-mdc-adgroup-admin",
    "${local.product}-mdc-adgroup-developers",
    "${local.product}-mdc-adgroup-externals",
    ],

    # OnCall group only in prod
    var.env_short == "p" ? [
      "${local.product}-idpay-adgroup-oncall",
      "${local.product}-srtp-adgroup-oncall",
      "${local.product}-mdc-adgroup-oncall"
    ] : []
  )



  ### Kubernetes
  kubernetes_cluster_name                = "${local.project}-aks"
  kubernetes_cluster_resource_group_name = "${local.product}-itn-core-aks-rg"

  ### KV
  kv_cicd_name           = "${local.product}-itn-cicd-kv"
  kv_core_name           = "${local.product}-itn-core-kv"
  kv_resource_group_name = "${local.product}-itn-core-sec-rg"

  #DNS
  internal_dns_zone_name = join(".", compact([var.location_short, "internal", var.env_short == "p" ? "" : var.env, var.prefix, "pagopa.it"]))

  ### ArgoCD
  argocd_namespace            = "argocd"
  argocd_service_account_name = "argocd-server"

  ### KeyCloak
  keycloak_hostname = "keycloak.${local.internal_dns_zone_name}"
}
