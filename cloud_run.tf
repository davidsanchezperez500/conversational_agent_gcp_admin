# Cloud Run service for the conversational agent frontend
module "frontend_service" {
  source       = "./modules/cloud-run-service"
  project_id   = var.project_id
  region       = var.region
  environment  = var.environment
  service_name = "frontend-agent"
  image_url    = "us-east1-docker.pkg.dev/conversational-agent-commonsec/docker-repository-${var.environment}/frontend:latest"

  secrets = {
    "API_KEY" = "projects/579307523881/secrets/api-key-front-${var.environment}"
  }

  ingress_traffic = "INGRESS_TRAFFIC_ALL"
  business_tags   = local.business_tags
  component_label = "frontend"
  depends_on      = [google_project_iam_policy.conversational_agent_project]
}

resource "google_cloud_run_v2_service_iam_member" "frontend_invokes_chatbot" {
  location = module.chatbot_agent.location
  name     = module.chatbot_agent.service_name
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "serviceAccount:${module.frontend_service.service_account_email}"
}


# Clud Run service for the chatbot agent backend
module "chatbot_agent" {
  source           = "./modules/cloud-run-service"
  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  service_name     = "chatbot-agent"
  image_url        = "us-east1-docker.pkg.dev/conversational-agent-commonsec/docker-repository-${var.environment}/chatbot-backend:latest"
  vpc_connector_id = google_vpc_access_connector.vpc_connector.id
  business_tags    = local.business_tags
  component_label  = "backend"
  depends_on       = [google_project_iam_policy.conversational_agent_project]

}

/* resource "google_bigtable_instance_iam_member" "new_bigtable_access" {
  project  = var.project_id
  instance = google_bigtable_instance.conversational_agent.name
  role     = "roles/bigtable.user"
  member   = "serviceAccount:${module.chatbot_agent.service_account_email}" 
} */

# Cloud Run service for the conversational agent backend
module "conversational_agent" {
  source           = "./modules/cloud-run-service"
  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  service_name     = "conversational-agent"
  image_url        = "us-east1-docker.pkg.dev/conversational-agent-commonsec/docker-repository-${var.environment}/conversational-backend:latest"
  vpc_connector_id = google_vpc_access_connector.vpc_connector.id
  cpu_limit        = var.cpu_limit_cloud_run_conversational
  memory_limit     = var.memory_limit_cloud_run_conversational
  business_tags    = local.business_tags
  component_label  = "backend"
  depends_on       = [google_project_iam_policy.conversational_agent_project]
}

/* resource "google_bigtable_instance_iam_member" "conversational_bigtable_access" {
  project  = var.project_id
  instance = google_bigtable_instance.conversational_agent.name
  role     = "roles/bigtable.user"
  member   = "serviceAccount:${module.conversational_agent.service_account_email}" 
}
*/

resource "google_project_iam_member" "cloud_run_to_gemini" {
  project = var.project_id
  role    = "roles/aiplatform.endpointUser"
  member  = "serviceAccount:${module.conversational_agent.service_account_email}"
}
