environment                           = "dev"
project_id                            = "conversational-agent-dev"
project_number                        = "884109815379"
region                                = "us-east1"
ip_cidr_range_subnet_main             = "10.10.0.0/20"
ip_cidr_range_subnet_connector        = "10.42.1.0/28"
ip_cidr_range_vpc_connector           = "10.42.2.0/28"
num_nodes_bigtable_cluster            = 1
storage_type_bigtable_cluster         = "SSD"
stream_retention_bigtable_table       = "24h0m0s"
retention_period_bigtable_backup      = "72h0m0s"
frequency_bigtable_backup             = "24h0m0s"
cpu_limit_cloud_run_conversational    = "2"
memory_limit_cloud_run_conversational = "1Gi"

enable_apis = [
  "compute.googleapis.com",
  "run.googleapis.com",
  "cloudfunctions.googleapis.com",
  "eventarc.googleapis.com",
  "aiplatform.googleapis.com",
  "networkconnectivity.googleapis.com",
  "vpcaccess.googleapis.com",
  "pubsub.googleapis.com",
  "bigtable.googleapis.com",
  "secretmanager.googleapis.com",
  "storage.googleapis.com",
  "cloudresourcemanager.googleapis.com",
  "cloudkms.googleapis.com",
  "cloudidentity.googleapis.com",
  "cloudbilling.googleapis.com",
  "cloudbuild.googleapis.com",
  "containerregistry.googleapis.com",
  "artifactregistry.googleapis.com",
  "logging.googleapis.com",
  "monitoring.googleapis.com",
  "servicenetworking.googleapis.com",
  "dns.googleapis.com",
]

owners_role = [
  "roles/owner",
]

owners_members = [
  "user:project.new.hope.data@gmail.com",
  "serviceAccount:github-runner-sa-dev@conversational-agent-dev.iam.gserviceaccount.com"
]

editors_role = [
  "roles/editor",
  "roles/secretmanager.secretAccessor",
  "roles/vpcaccess.serviceAgent"
]

editors_members = [
  "serviceAccount:884109815379-compute@developer.gserviceaccount.com",
  "serviceAccount:884109815379@cloudbuild.gserviceaccount.com",
  "serviceAccount:884109815379@cloudservices.gserviceaccount.com",
  "serviceAccount:service-884109815379@gcp-sa-vpcaccess.iam.gserviceaccount.com",
]
