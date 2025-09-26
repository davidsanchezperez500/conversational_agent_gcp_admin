environment                        = "itg"
project_id                         = "conversational-agent-itg"
project_number                     = "630186343641"
region                             = "us-east1"
owner_email                        = "project.new.hope.data@gmail.com"
ip_cidr_range_subnet_main          = "10.10.16.0/20"
ip_cidr_range_subnet_connector     = "10.42.1.16/28"
ip_cidr_range_vpc_connector        = "10.42.2.16/28"
machine_type_ai_deployment         = "n1-standard-2"
accelerator_type_ai_deployment     = "NVIDIA_TESLA_T4"
accelerator_count_ai_deployment    = 1
min_replica_count_ai_deployment    = 1
max_replica_count_ai_deployment    = 2
metric_name_ai_deployment          = "aiplatform.googleapis.com/prediction/online/accelerator/duty_cycle"
target_ai_deployment               = 60
num_nodes_bigtable_cluster         = 1
storage_type_bigtable_cluster      = "HDD"
min_nodes_bigtable_cluster         = 1
max_nodes_bigtable_cluster         = 3
cpu_target_bigtable_cluster        = 50
storage_target_bigtable_cluster    = 8192
stream_retention_bigtable_table    = "24h0m0s"
retention_period_bigtable_backup   = "72h0m0s"
frequency_bigtable_backup          = "24h0m0s"
min_instances_vpc_access_connector = 2
max_instances_vpc_access_connector = 3
ack_deadline_seconds               = 300
cpu_limit_cloud_run_worker         = "2"
memory_limit_cloud_run_worker      = "1Gi"

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
  "serviceAccount:github-runner-sa-itg@conversational-agent-itg.iam.gserviceaccount.com"
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
