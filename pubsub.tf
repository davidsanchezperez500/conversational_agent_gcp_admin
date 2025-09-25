resource "google_pubsub_topic" "vertex_request_topic" {
  project      = var.project_id
  name         = "vertex-ai-request-${var.environment}"
  kms_key_name = google_kms_crypto_key.pubsub_crypto_key.id

  message_storage_policy {
    allowed_persistence_regions = ["us-east1"]
  }
  depends_on = [
    google_kms_crypto_key_iam_member.pubsub_key_iam
  ]
}

resource "google_pubsub_subscription" "vertex_request_sub" {
  project = var.project_id
  name    = "vertex-ai-request-sub-${var.environment}"
  topic   = google_pubsub_topic.vertex_request_topic.name

  push_config {
    push_endpoint = "${module.worker_agent.service_url}/pubsub_handler"

    oidc_token {
      service_account_email = module.worker_agent.service_account_email
    }
  }

  ack_deadline_seconds = var.ack_deadline_seconds
}
