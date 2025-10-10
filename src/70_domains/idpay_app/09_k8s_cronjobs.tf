resource "kubernetes_cron_job_v1" "cancel_pending_transactions" {
  metadata {
    name      = "cancel-pending-transactions"
    namespace = var.domain
    labels = {
      app = "idpay-app"
    }
  }

  spec {
    schedule = "0 4 * * *"  # ogni giorno alle 04:00 UTC
    concurrency_policy = "Forbid"

    job_template {
      metadata {
        name = "cancel-pending-transactions-job"
        labels = {
          app = "idpay-app"
        }
      }
      spec {
        template {
          metadata {
            labels = {
              app = "idpay-app"
            }
          }
          spec {
            container {
              name  = "cancel-pending-transactions"
              image = "curlimages/curl:8.1.2"
              args  = [
                "-X", "DELETE",
                "https://${local.idpay_ingress_url}/idpaypayment/idpay/payment/pendingTransactions"
              ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
