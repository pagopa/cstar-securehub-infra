resource "kubernetes_cron_job_v1" "cancel_pending_transactions" {
  metadata {
    name      = "cancel-pending-transactions"
    namespace = var.namespace
    labels = {
      app = "idpay-app"
    }
  }

  spec {
    schedule = "0 4 * * *"  # ogni giorno alle 04:00 UTC

    job_template {
      spec {
        template {
          spec {
            container {
              name  = "cancel-pending-transactions"
              image = "curlimages/curl:8.1.2"
              args  = [
                "-X", "DELETE",
                "http://${var.service_name}.${var.namespace}.svc.cluster.https://idpay.itn.internal.dev.cstar.pagopa.it/idpaypayment/idpay/payment/pendingTransactions"
              ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
