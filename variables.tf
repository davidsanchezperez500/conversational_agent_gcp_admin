variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "project_number" {
  type        = string
  description = "The project number to host the cluster in (required)"
}

variable "location_type" {
  type        = string
  description = "Either regional or zonal"
  default     = "zonal"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "enable_apis" {
  type        = set(string)
  description = "APIs enable in all the projects of the environments"
}

variable "owners_role" {
  type        = list(string)
  description = "List of roles owners"
}

variable "owners_members" {
  type        = list(string)
  description = "List of users to be assigned to the owners"
}

variable "repository_owner_id" {
  type        = string
  description = "The GitHub repository owner ID for Workload Identity Federation"
  default     = "39903115" # davidsanchezperez500
}

variable "ip_cidr_range_subnet_main" {
  type        = string
  description = "The IP CIDR range for the main subnet"
}

variable "ip_cidr_range_subnet_connector" {
  type        = string
  description = "The IP CIDR range for the connector subnet"
}

variable "ip_cidr_range_vpc_connector" {
  type        = string
  description = "The IP CIDR range for the VPC Access Connector"
}

variable "editors_role" {
  type        = list(string)
  description = "List of roles editors"
}

variable "editors_members" {
  type        = list(string)
  description = "List of users to be assigned to the editors"
}

variable "machine_type_ai_deployment" {
  type        = string
  description = "The machine type to use for the deployment"
}

variable "accelerator_type_ai_deployment" {
  type        = string
  description = "The accelerator type to use for the deployment"
}

variable "accelerator_count_ai_deployment" {
  type        = number
  description = "The number of accelerators to use for the deployment"
}

variable "min_replica_count_ai_deployment" {
  type        = number
  description = "The minimum number of replicas to use for the deployment"
}

variable "max_replica_count_ai_deployment" {
  type        = number
  description = "The maximum number of replicas to use for the deployment"
  default     = 2
}

variable "metric_name_ai_deployment" {
  type        = string
  description = "The metric name to use for the deployment autoscaling"
}

variable "target_ai_deployment" {
  type        = number
  description = "The target value to use for the deployment autoscaling"
}

variable "owner_email" {
  type        = string
  description = "The email of the project owner"
}

variable "num_nodes_bigtable_cluster" {
  type        = number
  description = "The number of nodes for the Bigtable cluster"
}


variable "storage_type_bigtable_cluster" {
  type        = string
  description = "The storage type for the Bigtable cluster"
}

variable "min_nodes_bigtable_cluster" {
  type        = number
  description = "The minimum number of nodes for the Bigtable cluster with autoscaling"
}

variable "max_nodes_bigtable_cluster" {
  type        = number
  description = "The maximum number of nodes for the Bigtable cluster with autoscaling"
}

variable "cpu_target_bigtable_cluster" {
  type        = number
  description = "The CPU target for the Bigtable cluster with autoscaling"
}

variable "storage_target_bigtable_cluster" {
  type        = number
  description = "The storage target for the Bigtable cluster with autoscaling"
}

variable "stream_retention_bigtable_table" {
  type        = string
  description = "The change stream retention for the Bigtable table"
}

variable "retention_period_bigtable_backup" {
  type        = string
  description = "The retention period for the Bigtable backups"
}

variable "frequency_bigtable_backup" {
  type        = string
  description = "The frequency for the Bigtable backups"
}

variable "min_instances_vpc_access_connector" {
  type        = number
  description = "The minimum number of instances for the VPC Access Connector"
}

variable "max_instances_vpc_access_connector" {
  type        = number
  description = "The maximum number of instances for the VPC Access Connector"
}

variable "ack_deadline_seconds" {
  type        = number
  description = "The acknowledgment deadline for Pub/Sub subscriptions"
}

variable "cpu_limit_cloud_run_worker" {
  type        = string
  description = "CPU limit for the Cloud Run services for the worker"
}

variable "memory_limit_cloud_run_worker" {
  type        = string
  description = "Memory limit for the Cloud Run services for the worker"
}

variable "api_key_front_value" {
  type        = string
  description = "The value of the API key to be stored in Secret Manager"
  sensitive   = true
}
