variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The region where the Cloud Run service will be deployed."
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string
}

variable "service_name" {
  description = "The base name for the Cloud Run service (e.g., chatbot-agent)."
  type        = string
}

variable "image_url" {
  description = "The URL of the container image to deploy."
  type        = string
}

variable "business_tags" {
  description = "A map of business tags to apply to the resource."
  type        = map(string)
  default     = {}
}

variable "component_label" {
  description = "The component label for this service (e.g., backend-chatbot)."
  type        = string
}

variable "cpu_limit" {
  description = "CPU limit for the container (e.g., '1')."
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit for the container (e.g., '512Mi')."
  type        = string
  default     = "512Mi"
}

variable "container_port" {
  description = "The port the container listens on."
  type        = number
  default     = 8080
}

variable "port_name" {
  description = "The name of the port (e.g., 'http1')."
  type        = string
  default     = "http1"
}

variable "vpc_connector_id" {
  description = "The self_link of the Serverless VPC Access Connector. Set to null to deploy a public service."
  type        = string
  default     = null
}

variable "vpc_egress" {
  description = "VPC egress setting ('ALL_TRAFFIC' or 'PRIVATE_RANGES_ONLY')."
  type        = string
  default     = "ALL_TRAFFIC"
}

variable "ingress_traffic" {
  description = "Ingress traffic setting ('INGRESS_TRAFFIC_ALL' or 'INGRESS_TRAFFIC_INTERNAL_ONLY')."
  type        = string
  default     = "INGRESS_TRAFFIC_INTERNAL_ONLY"
}

variable "secrets" {
  description = "A map of secret names and their corresponding Secret Manager resource IDs."
  type        = map(string)
  default     = {}
}
