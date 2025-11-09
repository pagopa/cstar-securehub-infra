locals {
  product     = "${var.prefix}-${var.env_short}"
  product_ita = "${var.prefix}-${var.env_short}-${var.location_short}"
  project     = "${var.prefix}-${var.env_short}-${var.location_short}-${var.env}"

  argocd_application_owners = [
    "diego.lagosmorales@pagopa.it",
    "matteo.alongi@pagopa.it",
    "marco.mari@pagopa.it",
    "umberto.coppolabottazzi@pagopa.it",
    "fabio.felici@pagopa.it"
  ]

  argocd_entra_groups_allowed = [
    #Global groups
    "${var.prefix}-${var.env_short}-adgroup-admin",
    "${var.prefix}-${var.env_short}-adgroup-developers",
    "${var.prefix}-${var.env_short}-adgroup-externals",
    #SRTP Groups
    "${var.prefix}-${var.env_short}-srtp-adgroup-admin",
    "${var.prefix}-${var.env_short}-srtp-adgroup-developers",
    "${var.prefix}-${var.env_short}-srtp-adgroup-externals",
    #IDPay Groups
    "${var.prefix}-${var.env_short}-idpay-adgroup-admin",
    "${var.prefix}-${var.env_short}-idpay-adgroup-developers",
    "${var.prefix}-${var.env_short}-idpay-adgroup-externals",
  ]



  ### Kubernetes
  kubernetes_cluster_name                = "cstar-${var.env_short}-itn-${var.env}-aks"
  kubernetes_cluster_resource_group_name = "cstar-${var.env_short}-itn-core-aks-rg"

  ### KV
  kv_name                = "cstar-${var.env_short}-itn-cicd-kv"
  kv_resource_group_name = "cstar-${var.env_short}-itn-core-sec-rg"

  ### ArgoCD
  argocd_hostname             = var.env == "prod" ? "argocd.itn.internal.cstar.pagopa.it" : "argocd.itn.internal.${var.env}.cstar.pagopa.it"
  argocd_namespace            = "argocd"
  argocd_service_account_name = "argocd-server"
}
