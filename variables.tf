variable "project_id" {
  type        = string
  description = "The project ID to host the cluster in (required)"
}

variable "project_number" {
  type        = string
  description = "The project number to host the cluster in (required)"
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

variable "num_nodes_bigtable_cluster" {
  type        = number
  description = "The number of nodes for the Bigtable cluster"
}

variable "storage_type_bigtable_cluster" {
  type        = string
  description = "The storage type for the Bigtable cluster"
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

variable "api_key_front_value" {
  type        = string
  description = "The value of the API key to be stored in Secret Manager"
  sensitive   = true
}
variable "cpu_limit_cloud_run_conversational" {
  type        = string
  description = "The CPU limit for the conversational agent Cloud Run service"
}

variable "memory_limit_cloud_run_conversational" {
  type        = string
  description = "The memory limit for the conversational agent Cloud Run service"
}

variable "vpn_project_id" {
  type    = string
  default = "conversational-agent-commonnet"
}

variable "vpn_network_name" {
  type    = string
  default = "vpc-vpn-ha"
}
