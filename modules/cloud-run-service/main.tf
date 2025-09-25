# 1. Create a Service Account (SA) for the Cloud Run service.
resource "google_service_account" "service_sa" {
  account_id   = "sa-${var.service_name}-${var.environment}"
  display_name = "SA for ${var.service_name} ${var.environment}"
  project      = var.project_id
}

# 2. Create the Cloud Run service.
resource "google_cloud_run_v2_service" "service" {
  name     = "${var.service_name}-${var.environment}"
  location = var.region
  project  = var.project_id

  template {
    service_account = google_service_account.service_sa.email

    containers {
      image = var.image_url
      ports {
        name           = var.port_name
        container_port = var.container_port
      }

      resources {
        limits = {
          memory = var.memory_limit
          cpu    = var.cpu_limit
        }
      }
      dynamic "env" {
        for_each = var.secrets
        content {
          name = env.key
          value_source {
            secret_key_ref {
              secret  = env.value
              version = "latest"
            }
          }
        }
      }
    }
    dynamic "vpc_access" {
      for_each = var.vpc_connector_id != null ? [1] : []
      content {
        connector = var.vpc_connector_id
        egress    = var.vpc_egress
      }
    }
  }


  ingress = var.ingress_traffic


  labels = merge(
    var.business_tags,
    {
      component = var.component_label
    }
  )
}
