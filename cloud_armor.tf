resource "google_compute_security_policy" "frontend_policy" {
  name        = "cloud-armor-frontend-${var.environment}"
  project     = var.project_id
  description = "Security policy for conversational agent frontend"

  rule {
    action   = "deny(403)"
    priority = "500"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('cve-canary')"
      }
    }
    description = "Block Log4Shell (CVE-2021-44228) exploit attempts."
  }

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Allow all standard traffic."
  }

  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default catch-all rule."
  }

  labels = merge(
    local.business_tags,
    {
      component = "frontend"
    }
  )
}
