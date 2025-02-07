resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

module "aks_prometheus_install" {
  source = "./.terraform/modules/__v3__/kubernetes_prometheus_install"

  prometheus_namespace    = kubernetes_namespace.prometheus.metadata[0].name
  storage_class_name      = "default-zrs" #example of ZRS storage class created by kubernetes_storage_class
  prometheus_crds_enabled = true
}
