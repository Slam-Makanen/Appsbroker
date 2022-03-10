# VPC network
resource "google_compute_network" "int_lb_network" {
  name                    = "int-lb-network"
  provider                = google-beta
  auto_create_subnetworks = false
}

# Proxy-only subnet
resource "google_compute_subnetwork" "appsbroker_proxy_subnet" {
  name          = "appsbroker-proxy-subnet"
  provider      = google-beta
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = google_compute_network.int_lb_network.id
}

# Reserved IP address
resource "google_compute_global_address" "default" {
  provider = google-beta
  name     = "apps-lb-static-ip"
}

# Forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "apps-lb-forwarding-rule"
  provider              = google-beta
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

# HTTP proxy
resource "google_compute_target_http_proxy" "default" {
  name     = "target-http-proxy"
  provider = google-beta
  url_map  = google_compute_url_map.default.id
}

# URL map
resource "google_compute_url_map" "default" {
  name            = "url-map"
  provider        = google-beta
  default_service = google_compute_backend_service.appsbroker_backend.id
}

# Backend
resource "google_compute_backend_service" "appsbroker_backend" {
  name                            = "appsbroker-backend"
  protocol                        = "HTTP"
  load_balancing_scheme           = "EXTERNAL"
  timeout_sec                     = 10
  enable_cdn                      = true
  connection_draining_timeout_sec = 300
  backend {
    group           = google_compute_region_instance_group_manager.appsbroker_igm.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.health_check.id]
}
