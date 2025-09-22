resource "kubernetes_namespace" "influxdb_namespace" {
  metadata {
    name = "platform-influxdb"
  }
}

resource "argocd_application" "influxdb2" {
  count = var.env_short != "p" ? 1 : 0

  metadata {
    name      = "influxdb2"
    namespace = var.domain
    labels = {
      name   = "influxdb2"
      domain = var.domain
      class  = "observability"
      area   = var.domain
    }
  }

  spec {
    project = argocd_project.platform_project.metadata.name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.influxdb_namespace.metadata[0].name
    }

    source {
      repo_url        = "https://helm.influxdata.com/"
      chart           = "influxdb2"
      target_revision = var.influxdb2_helm.chart_version

      helm {
        release_name = "influxdb2"
        values = yamlencode({
          image = {
            repository = var.influxdb2_helm.image.name
            tag        = var.influxdb2_helm.image.tag
          }
          ingress = {
            enabled  = true
            tls      = true
            hostname = local.influxdb_url
            path     = "/(.*)"
            annotations = {
              "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
            }
          }
        })
      }
    }
  }
}
