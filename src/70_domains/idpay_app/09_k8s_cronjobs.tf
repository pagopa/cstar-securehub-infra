resource "kubernetes_cron_job_v1" "cancel_pending_transactions" {
  metadata {
    name      = "cancel-pending-transactions"
    namespace = var.domain
    labels = {
      app = "idpay-app"
    }
  }

  spec {
    schedule           = "0 0 * * *" # runs at 00:00 everyday
    timezone           = "Europe/Rome"
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
              image = "curlimages/curl:8.1.2@sha256:fcf8b68aa7af25898d21b47096ceb05678665ae182052283bd0d7128149db55f"
              args = [
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


resource "kubernetes_cron_job_v1" "cancel_expired_vouchers" {
  metadata {
    name      = "cancel-expired-vouchers"
    namespace = var.domain
    labels = {
      app = "idpay-app"
    }
  }

  spec {
    schedule           = "5 0 * * *" #00:05
    timezone           = "Europe/Rome"
    concurrency_policy = "Forbid"

    job_template {
      metadata {
        name = "cancel-expired-vouchers-job"
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
              name  = "cancel-expired-vouchers"
              image = "curlimages/curl:8.1.2@sha256:fcf8b68aa7af25898d21b47096ceb05678665ae182052283bd0d7128149db55f"
              args = [
                "-X", "POST",
                "https://${local.idpay_ingress_url}/idpaypayment/idpay/transactions/expired/initiatives/${var.idpay_bel_initiative_id}/update-status"
              ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}

resource "kubernetes_cron_job_v1" "reminder_voucher_expiration" {
  metadata {
    name      = "reminder-voucher-expiration"
    namespace = var.domain
    labels = {
      app = "idpay-app"
    }
  }

  spec {
    schedule           = "0 1 * * *" # 01:00
    timezone           = "Europe/Rome"
    concurrency_policy = "Forbid"

    job_template {
      metadata {
        name = "reminder-voucher-expiration-job"
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
              name  = "reminder-voucher-expiration"
              image = "curlimages/curl:8.1.2@sha256:fcf8b68aa7af25898d21b47096ceb05678665ae182052283bd0d7128149db55f"
              args = [
                "-X", "POST",
                "https://${local.idpay_ingress_url}/idpaywallet/idpay/wallet/batch/run/${var.idpay_bel_initiative_id}"
              ]
            }
            restart_policy = "OnFailure"
          }
        }
      }
    }
  }
}
