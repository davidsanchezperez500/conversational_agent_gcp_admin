output "service_url" {
  description = "The publicly accessible URL of the Cloud Run service."
  value       = google_cloud_run_v2_service.service.uri
}

output "service_account_email" {
  description = "The email of the Service Account used by this Cloud Run instance."
  value       = google_service_account.service_sa.email
}

output "service_name" {
  description = "The full name of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.service.name
}

output "location" {
  description = "The region where the Cloud Run service is deployed."
  value       = google_cloud_run_v2_service.service.location
}
