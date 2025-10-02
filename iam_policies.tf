resource "google_project_iam_policy" "conversational_agent_project" {
  project     = var.project_id
  policy_data = data.google_iam_policy.conversational_agent_project_policy.policy_data
}

data "google_iam_policy" "conversational_agent_project_policy" {

  #  owners
  dynamic "binding" {
    for_each = var.owners_role
    content {
      role    = binding.value
      members = var.owners_members
    }
  }

  # editors
  dynamic "binding" {
    for_each = var.editors_role
    content {
      role    = binding.value
      members = var.editors_members
    }
  }

  # ==============================================================================
  # BINDINGS FOR ENABLED API SERVICE AGENTS
  # These bindings assign necessary roles to Google's internal service accounts
  # (Service Agents) so that GCP services can manage resources within the project.
  # ==============================================================================
  binding {
    role = "roles/cloudfunctions.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@gcf-admin-robot.iam.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/cloudbuild.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@gcp-sa-cloudbuild.iam.gserviceaccount.com",
    ]
  }

  /*   binding {
    role = "projects/conversational-agent-${var.environment}/roles/terraformDeployerAdmin" 
    members = [
      "serviceAccount:${google_service_account.github_runner.email}",
    ]
  } */

  /*   binding {
    role = "roles/servicenetworking.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@service-networking.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/servicenetworking.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@service-networking.iam.gserviceaccount.com",
    ]
  }
  */
  binding {
    role = "roles/iam.serviceAccountTokenCreator"
    members = [
      "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com",
      "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com"
    ]
  }

  binding {
    role = "roles/run.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@serverless-robot-prod.iam.gserviceaccount.com"
    ]
  }

  binding {
    role = "roles/containeranalysis.ServiceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@container-analysis.iam.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/containerscanning.ServiceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@gcp-sa-containerscanning.iam.gserviceaccount.com",
    ]
  }
  binding {
    role = "roles/artifactregistry.serviceAgent"
    members = [
      "serviceAccount:service-${var.project_number}@gcp-sa-artifactregistry.iam.gserviceaccount.com",
    ]
  }

  binding {
    role = "roles/aiplatform.endpointUser"
    members = [
      "serviceAccount:sa-conversational-agent-${var.environment}@conversational-agent-${var.environment}.iam.gserviceaccount.com",
    ]
  }

  depends_on = [google_project_service.project]
}
