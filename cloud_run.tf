# Cloud Run service for the conversational agent frontend
module "frontend_service" {
  source       = "./modules/cloud-run-service"
  project_id   = var.project_id
  region       = var.region
  environment  = var.environment
  service_name = "frontend-agent"
  image_url    = "us-east1-docker.pkg.dev/conversational-agent-${var.environment}/docker-repository-${var.environment}/frontend:latest"

  secrets = {
    "API_KEY" = google_secret_manager_secret.api_key_front.id
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

resource "google_secret_manager_secret_iam_member" "secret_binding" {
  secret_id = google_secret_manager_secret.api_key_front.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${module.frontend_service.service_account_email}"
}

# Clud Run service for the chatbot agent backend
module "chatbot_agent" {
  source           = "./modules/cloud-run-service"
  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  service_name     = "chatbot-agent"
  image_url        = "us-east1-docker.pkg.dev/conversational-agent-${var.environment}/docker-repository-${var.environment}/chatbot-backend:latest"
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
}
 */
# Cloud Run service for the conversational agent backend
module "conversational_agent" {
  source           = "./modules/cloud-run-service"
  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  service_name     = "conversational-agent"
  image_url        = "us-east1-docker.pkg.dev/conversational-agent-${var.environment}/docker-repository-${var.environment}/conversational-backend:latest"
  vpc_connector_id = google_vpc_access_connector.vpc_connector.id
  business_tags    = local.business_tags
  component_label  = "backend"
  depends_on       = [google_project_iam_policy.conversational_agent_project]
}

/* resource "google_bigtable_instance_iam_member" "conversational_bigtable_access" {
  project  = var.project_id
  instance = google_bigtable_instance.conversational_agent.name
  role     = "roles/bigtable.user"
  member   = "serviceAccount:${module.conversational_agent.service_account_email}" 
} */

resource "google_pubsub_topic_iam_member" "conversational_publisher_access" {
  project = var.project_id
  topic   = google_pubsub_topic.vertex_request_topic.name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${module.conversational_agent.service_account_email}"
}

# Cloud Run service for the worker backend  
module "worker_agent" {
  source           = "./modules/cloud-run-service"
  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  service_name     = "worker-agent"
  image_url        = "us-east1-docker.pkg.dev/conversational-agent-${var.environment}/docker-repository-${var.environment}/worker-backend:latest"
  vpc_connector_id = google_vpc_access_connector.vpc_connector.id
  cpu_limit        = var.cpu_limit_cloud_run_worker
  memory_limit     = var.memory_limit_cloud_run_worker
  business_tags    = local.business_tags
  component_label  = "backend"
  depends_on       = [google_project_iam_policy.conversational_agent_project]
}

/* resource "google_bigtable_instance_iam_member" "worker_bigtable_access" {
  project  = var.project_id
  instance = google_bigtable_instance.conversational_agent.name
  role     = "roles/bigtable.user"
  member   = "serviceAccount:${module.worker_agent.service_account_email}" 
}
 */
resource "google_project_iam_member" "vertex_ai_user_binding" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${module.worker_agent.service_account_email}"
}

