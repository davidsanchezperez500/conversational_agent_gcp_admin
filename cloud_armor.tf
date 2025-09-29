resource "google_compute_security_policy" "frontend_policy" {
  name        = "cloud-armor-frontend-${var.environment}"
  project     = var.project_id
  description = "Simplified deny-by-default Cloud Armor policy"

  rule {
    priority = 100
    action   = "deny(403)"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('cve-canary')"
      }
    }
    description = "Block Log4Shell (CVE-2021-44228) exploit attempts"
  }

  rule {
    priority = 200
    action   = "deny(403)"
    match {
      expr {
        expression = <<-EOT
          evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 3}) ||
          evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 3})
        EOT
      }
    }
    description = "Block SQL injection and XSS attempts"
  }

  rule {
    priority = 400
    action   = "allow"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = [
          "130.211.0.0/22",
          "35.191.0.0/16"
        ]
      }
    }
    description = "Allow Google LB health check probes"
  }

  rule {
    priority = 2147483647
    action   = "deny(403)"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default deny - catch-all"
  }
}
