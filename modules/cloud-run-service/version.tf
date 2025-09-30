# Configure the Google Cloud provider
terraform {
  required_version = ">= 1.13.0, < 2.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.3.0, < 8.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 7.3.0, < 8.0.0"
    }
  }
}
