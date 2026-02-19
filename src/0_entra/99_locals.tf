locals {
  product = "${var.prefix}-${var.env_short}"
  project = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  argocd_application_owners = [
    "diego.lagosmorales@pagopa.it",
    "matteo.alongi@pagopa.it",
    "marco.mari@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "fabio.felici@pagopa.it"
  ]

  # These groups are allowed to be linked into the projects or global setup of ArgoCD
  # If not present here or in the extra variable, the user can login to ArgoCD but with nothing assigned
  argocd_entra_groups_allowed = concat([
    #Global groups
    "${local.product}-adgroup-admin",
    "${local.product}-adgroup-developers",
    "${local.product}-adgroup-externals",
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
  kv_name                = "${local.product}-itn-cicd-kv"
  kv_resource_group_name = "${local.product}-itn-core-sec-rg"

  ### ArgoCD
  argocd_hostname             = var.env == "prod" ? "argocd.itn.internal.cstar.pagopa.it" : "argocd.itn.internal.${var.env}.cstar.pagopa.it"
  argocd_namespace            = "argocd"
  argocd_service_account_name = "argocd-server"
}
