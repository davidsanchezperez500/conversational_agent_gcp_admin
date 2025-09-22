
# Create a KMS Key Ring and Crypto Key for Pub/Sub CMEK
resource "google_kms_key_ring" "pubsub_key_ring" {
  name     = "pubsub-keyring-${var.environment}"
  location = var.region
  project  = var.project_id
}

resource "google_kms_crypto_key" "pubsub_crypto_key" {
  name            = "pubsub-cmek-key-${var.environment}"
  key_ring        = google_kms_key_ring.pubsub_key_ring.id
  rotation_period = "7776000s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service_identity" "pubsub_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "pubsub.googleapis.com"

}

resource "google_kms_crypto_key_iam_member" "pubsub_key_iam" {
  crypto_key_id = google_kms_crypto_key.pubsub_crypto_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.pubsub_sa.email}"
}

# Create a KMS Key Ring and Crypto Key for Artifact Registry CMEK
resource "google_kms_key_ring" "keyring_artifact_registry_repository" {
  name     = "key-ring-artifact-repo-${var.environment}"
  location = var.region
}

resource "google_kms_crypto_key" "key_artifact_registry_repository" {
  name            = "key-artifact-repo-${var.environment}"
  key_ring        = google_kms_key_ring.keyring_artifact_registry_repository.id
  rotation_period = "7776000s"
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_artifact_registry_repository" {
  crypto_key_id = google_kms_crypto_key.key_artifact_registry_repository.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "user:${var.owner_email}",
    "serviceAccount:service-${var.project_number}@gcp-sa-artifactregistry.iam.gserviceaccount.com"
  ]
}
