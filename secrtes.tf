resource "google_secret_manager_secret" "api_key_front" {
  project   = var.project_id
  secret_id = "api-key-front"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "api_key_front_version" {
  secret      = google_secret_manager_secret.api_key_front.id
  secret_data = var.api_key_front_value
}

