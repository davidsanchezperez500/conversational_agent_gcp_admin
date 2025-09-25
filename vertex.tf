

# 1. Create the Vertex AI Endpoint resource.
# This serves as the network entry point for online prediction requests.
/* resource "google_vertex_ai_endpoint" "conversational_agent_endpoint" {
  project      = var.project_id
  location     = var.region
  name         = "conversational-agent-endpoint-${var.environment}"
  display_name = "conversational_agent-finetuned-endpoint-${var.environment}"

  labels = merge(
    local.business_tags,
    {
      component = "data"
    }
  )
}

# 2. Deploy the Model to the previously created Endpoint.
# This provisions compute resources (replicas) to serve the model.
resource "google_vertex_ai_deployment_resource_pool" "conversational_agent_pool" {
    region = var.region
    name   =  "conversational-agent-resource-pool-${var.environment}"
    dedicated_resources {
        machine_spec {
            machine_type      = var.machine_type_ai_deployment
            accelerator_type  = var.accelerator_type_ai_deployment
            accelerator_count = var.accelerator_count_ai_deployment
        }

        min_replica_count = var.min_replica_count_ai_deployment
        max_replica_count = var.max_replica_count_ai_deployment

        autoscaling_metric_specs {
            metric_name = var.metric_name_ai_deployment
            target      = var.target_ai_deployment
        }
    }
}
 */
