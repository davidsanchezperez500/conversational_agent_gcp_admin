# ==============================================================================
# 1. BIGTABLE INSTANCE (The container for all tables and clusters)
# ==============================================================================

/* resource "google_bigtable_instance" "conversational_agent" {
  project       = var.project_id
  name          = "con-agent-data-${var.environment}"
  display_name  = "con-agent Bigtable  ${var.environment}"

  # A cluster with fixed number of nodes.
  cluster {
    cluster_id   = "con-agent-cluster-1-${var.environment}"
    num_nodes    = var.num_nodes_bigtable_cluster
    storage_type = var.storage_type_bigtable_cluster
    zone         = "${var.region}-b"
  }

  # a cluster with auto scaling.
  cluster {
    cluster_id   = "con-agent-cluster-2-${var.environment}"
    storage_type = var.storage_type_bigtable_cluster
    zone         = "${var.region}-c"
    autoscaling_config {
      min_nodes      = var.min_nodes_bigtable_cluster
      max_nodes      = var.max_nodes_bigtable_cluster
      cpu_target     = var.cpu_target_bigtable_cluster
      storage_target = var.storage_target_bigtable_cluster
    }
  }

  labels = merge(
    local.business_tags,
    {
      component = "data"
    }
  )
}
 */
# ==============================================================================
# 2. BIGTABLE TABLE (The session history table)
# ==============================================================================

/* resource "google_bigtable_table" "conversational-agent_history_table" {
  project       = var.project_id
  instance_name = google_bigtable_instance.conversational_agent.id
  name          = "session_history_${var.environment}" # Table name referenced in app.py

  # Defines the Column Family 'data' for storing all conversational-agent session data.
  column_family {
    family = "data" 
  }

  change_stream_retention = var.stream_retention_bigtable_table

  automated_backup_policy {
    retention_period = var.retention_period_bigtable_backup
    frequency        = var.frequency_bigtable_backup
  }
}
 */
