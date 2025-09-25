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
