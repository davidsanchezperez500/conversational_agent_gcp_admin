# ==============================================================================
# 1. VPC NETWORK AND SUBNETWORKS
# ==============================================================================

# 1.1. Create the VPC Network
resource "google_compute_network" "vpc_agent" {
  name                    = "vpc-conversational-agent-${var.environment}"
  project                 = var.project_id
  auto_create_subnetworks = false # Recommended for granular control
  routing_mode            = "REGIONAL"
}

# 1.2. Create the Main Subnet (General application traffic)
resource "google_compute_subnetwork" "subnet_main" {
  name                     = "subnet-main-us-east1-${var.environment}"
  project                  = var.project_id
  ip_cidr_range            = var.ip_cidr_range_subnet_main
  region                   = var.region
  network                  = google_compute_network.vpc_agent.self_link
  private_ip_google_access = true
  log_config {
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

# 1.3. Create the Connector Subnet (Reserved for the VPC Access Connector)
resource "google_compute_subnetwork" "subnet_connector" {
  name                     = "subnet-connector-us-east1-${var.environment}"
  project                  = var.project_id
  ip_cidr_range            = var.ip_cidr_range_subnet_connector
  region                   = var.region
  network                  = google_compute_network.vpc_agent.self_link
  private_ip_google_access = true
  log_config {
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
    aggregation_interval = "INTERVAL_10_MIN"
  }
}

# ==============================================================================
# 2. SERVERLESS VPC ACCESS CONNECTOR
# ==============================================================================

resource "google_vpc_access_connector" "vpc_connector" {
  name          = "vpc-con-${var.environment}"
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.vpc_agent.self_link
  ip_cidr_range = var.ip_cidr_range_vpc_connector

  min_instances = 2
  max_instances = 3

}

# ==============================================================================
# 3. FIREWALL RULES (Minimum Privilege)
# ==============================================================================

# 3.1. Allow Internal Connector Traffic (Necessary for health checks and scaling)
resource "google_compute_firewall" "allow_connector_internal" {
  name    = "allow-connector-internal-traffic-${var.environment}"
  project = var.project_id
  network = google_compute_network.vpc_agent.name

  # Source and Destination: the connector instances' IP range
  source_ranges      = [google_vpc_access_connector.vpc_connector.ip_cidr_range]
  destination_ranges = [google_vpc_access_connector.vpc_connector.ip_cidr_range]

  allow {
    protocol = "all"
  }
}

# 3.2. Allow Egress Traffic to Google APIs (PSC)
resource "google_compute_firewall" "allow_connector_egress_to_google" {
  name      = "allow-connector-egress-to-google-apis-${var.environment}"
  project   = var.project_id
  network   = google_compute_network.vpc_agent.name
  direction = "EGRESS"

  # Source: the connector IP range
  source_ranges = [google_vpc_access_connector.vpc_connector.ip_cidr_range]

  allow {
    protocol = "tcp"
    ports    = ["443"] # HTTPS traffic only
  }

  # Destination: Google Access VIPs (Restricted VIP and default API range)
  destination_ranges = [
    "199.36.153.4/30", # Restricted VIP (PSC/VPC SC access)
    "35.199.192.0/19"  # Google API default range
  ]
}

resource "google_compute_firewall" "allow_connector_to_vpn" {
  name    = "allow-connector-to-vpn-${var.environment}"
  project = var.project_id
  network = google_compute_network.vpc_agent.name

  source_ranges      = [google_vpc_access_connector.vpc_connector.ip_cidr_range]
  destination_ranges = ["10.200.0.0/24"] # VPN range

  allow {
    protocol = "all"
  }
}


# ==============================================================================
# 4. PRIVATE SERVICE CONNECT (PSC) - Routing and DNS
# ==============================================================================

# 4.1. Create the Private DNS Zone for googleapis.com
resource "google_dns_managed_zone" "google_apis_zone" {
  name        = "google-apis-private-zone-${var.environment}"
  project     = var.project_id
  dns_name    = "googleapis.com."
  description = "Private DNS zone for Google APIs"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.vpc_agent.self_link
    }
  }
}

# 4.2. Create the CNAME Record (necessary for internal resolution)
resource "google_dns_record_set" "private_api_peering" {
  name         = "private.googleapis.com."
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.google_apis_zone.name
  rrdatas      = ["googleapis.com."]
}

# 4.3. Route for the Restricted VIP (Enforces PSC usage)
resource "google_compute_route" "psc_restricted_route" {
  name             = "route-psc-restricted-vip-${var.environment}"
  project          = var.project_id
  dest_range       = "199.36.153.4/30" # The Restricted VIP range
  network          = google_compute_network.vpc_agent.self_link
  next_hop_gateway = "https://www.googleapis.com/compute/v1/projects/conversational-agent-${var.environment}/global/gateways/default-internet-gateway"
  priority         = 100

}

# ==============================================================================
# 5. VPN PEERING
# ==============================================================================
resource "google_compute_network_peering" "host_to_vpn" {
  name                 = "peering-host-to-vpn-${var.environment}"
  network              = google_compute_network.vpc_agent.self_link
  peer_network         = "projects/${var.vpn_project_id}/global/networks/${var.vpn_network_name}"
  export_custom_routes = false
  import_custom_routes = true
}




# ==============================================================================
#### FRONTEND CLOUD RUN SERVICE WITH INTERNAL TRAFFIC ONLY AND LOAD BALANCER WITH CLOUD ARMOR ####
# ==============================================================================

# Create the Serverless NEG that links the Load Balancer to the Cloud Run Service
resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "neg-frontend-${var.environment}"
  project               = var.project_id
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  # CRITICAL: This links the NEG to the Cloud Run service
  cloud_run {
    service = module.frontend_service.service_name
  }
}

# create backend service for Cloud Run with Cloud Armor
resource "google_compute_backend_service" "frontend_backend" {
  name                  = "backend-frontend-${var.environment}"
  project               = var.project_id
  protocol              = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  security_policy       = google_compute_security_policy.frontend_policy.id

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.self_link
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }

}

# Create the URL map to route requests to the backend service
resource "google_compute_global_address" "frontend_ip" {
  name    = "ip-frontend-${var.environment}"
  project = var.project_id

  labels = merge(
    local.business_tags,
    {
      component = "frontend"
    }
  )
}

# Create the URL map to route requests to the backend service
resource "google_compute_url_map" "frontend_url_map" {
  name            = "urlmap-frontend-${var.environment}"
  project         = var.project_id
  default_service = google_compute_backend_service.frontend_backend.self_link
}

# Create the SSL Certificate for HTTPS
resource "google_compute_managed_ssl_certificate" "frontend_ssl" {
  name    = "ssl-frontend-${var.environment}"
  project = var.project_id

  managed {
    domains = ["frontend.example.${var.environment}.com"]
  }
}

# Create the Target HTTPS Proxy
resource "google_compute_target_https_proxy" "frontend_proxy" {
  name             = "proxy-frontend-${var.environment}"
  project          = var.project_id
  url_map          = google_compute_url_map.frontend_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.frontend_ssl.self_link]
}

# Create the Global Forwarding Rule to route traffic to the HTTPS Proxy
resource "google_compute_global_forwarding_rule" "frontend_forwarding_rule" {
  name                  = "forwarding-rule-frontend-${var.environment}"
  project               = var.project_id
  ip_address            = google_compute_global_address.frontend_ip.self_link
  port_range            = "443"
  target                = google_compute_target_https_proxy.frontend_proxy.self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

