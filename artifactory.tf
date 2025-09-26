resource "google_artifact_registry_repository" "repository_docker" {
  location      = var.region
  repository_id = "docker-repository-${var.environment}"
  description   = "Docker repository ${var.environment}"
  format        = "DOCKER"
  kms_key_name  = "projects/${var.project_id}/locations/${var.region}/keyRings/key-ring-artifact-repo-5-${var.environment}/cryptoKeys/key-artifact-repo-5-${var.environment}"
  vulnerability_scanning_config {
    enablement_config = "INHERITED"
  }
  depends_on = [
    google_kms_crypto_key_iam_binding.crypto_key_artifact_registry_repository
  ]
}

