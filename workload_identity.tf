resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool"
  project                   = var.project_id
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "github"
  description                        = "GitHub Actions identity pool provider"
  disabled                           = false
  attribute_condition                = "assertion.repository_owner_id == \"${var.repository_owner_id}\""

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
    "attribute.aud"        = "assertion.aud"
    "attribute.org"        = "assertion.repository_owner"
    "attribute.ref"        = "assertion.ref"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_binding" "github_runner_oidc" {
  service_account_id = google_service_account.github_runner.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/davidsanchezperez500/conversational_agent_gcp_admin",
  ]
}


