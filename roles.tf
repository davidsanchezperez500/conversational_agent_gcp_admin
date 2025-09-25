resource "google_project_iam_custom_role" "terraform_deployer_admin" {
  role_id     = "terraformDeployerAdmin"
  project     = var.project_id # Assumes the custom role is created in a centralized project
  title       = "Terraform Deployer Admin"
  description = "Minimum privilege role for the Terraform Service Account to manage key infrastructure."
  permissions = [
    # IAM (Allows creation and management of service accounts and setting roles) - CRITICAL
    "iam.roles.get",
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "resourcemanager.projects.setIamPolicy", # To manage IAM bindings
    "serviceusage.services.enable",          # To enable necessary APIs

    # Compute & Networking (VPC, VPN, Serverless VPC Access Connector)
    "compute.addresses.create",
    "compute.addresses.delete",
    "compute.addresses.get",
    "compute.firewalls.create",
    "compute.firewalls.delete",
    "compute.firewalls.get",
    "compute.routers.create",
    "compute.routers.delete",
    "compute.routers.get",
    "compute.routes.create",
    "compute.routes.delete",
    "compute.routes.get",
    "compute.networks.create",
    "compute.networks.delete",
    "compute.networks.update",
    "compute.subnetworks.create",
    "compute.subnetworks.delete",
    "compute.subnetworks.setIamPolicy",
    /*"compute.vpntunnels.create",
    "compute.vpntunnels.delete",
    "compute.vpntunnels.get", */
    "vpcaccess.connectors.create",
    "vpcaccess.connectors.delete",
    "vpcaccess.connectors.get",

    # Cloud Run (Service Deployment)
    "run.services.create",
    "run.services.delete",
    "run.services.get",
    "run.services.setIamPolicy",
    "run.services.update",

    # Cloud Build & Artifact Registry (Required for CI/CD pipelines)
    "cloudbuild.builds.create",
    "artifactregistry.repositories.create",
    "artifactregistry.repositories.delete",
    "artifactregistry.repositories.get",

    # Bigtable (Session Context Management)
    "bigtable.instances.create",
    "bigtable.instances.delete",
    "bigtable.instances.get",
    "bigtable.tables.create",
    "bigtable.tables.delete",
    "bigtable.tables.get",

    # Vertex AI (LLM Endpoints Management)
    "aiplatform.endpoints.create",
    "aiplatform.endpoints.delete",
    "aiplatform.endpoints.get",
    "aiplatform.models.update",
    "aiplatform.models.upload",
    "aiplatform.models.get",

    # Secret Manager and KMS (SAP Credentials and Key Management)
    "secretmanager.secrets.create",
    "secretmanager.secrets.delete",
    "secretmanager.secrets.get",
    # "cloudkms.cryptokeys.create",
    /*     "cloudkms.cryptokeys.delete",
    "cloudkms.cryptokeys.get",
    "cloudkms.keyrings.create",
    "cloudkms.keyrings.delete",
    "cloudkms.keyrings.get", */

    # Cloud Storage (Required for Terraform backend and logging buckets)
    "storage.buckets.create",
    "storage.buckets.delete",
    "storage.buckets.get",
  ]
}
