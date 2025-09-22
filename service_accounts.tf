resource "google_service_account" "github_runner" {
  account_id   = "github-runner-sa-${var.environment}"
  display_name = "Service Account for GitHub Runner ${var.environment}"
}
