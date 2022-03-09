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

# Backend subnet
resource "google_compute_subnetwork" "int_lb_subnet" {
  name          = "appsbroker-subnet"
  provider      = google-beta
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.int_lb_network.id
}

# HTTP target proxy
resource "google_compute_region_target_http_proxy" "default" {
  name     = "int-lb-target-http-proxy"
  provider = google-beta
  region   = var.region
  url_map  = google_compute_region_url_map.default.id
}

# URL map
resource "google_compute_region_url_map" "default" {
  name            = "int-lb-regional-url-map"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.appsbroker_backend.id
}

# Frontend
resource "google_compute_forwarding_rule" "appsbroker_fwd_rule" {
  name                  = "appsbroker-forwarding-rule"
  region                = var.region
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.int_lb_network.id
  subnetwork            = google_compute_subnetwork.int_lb_subnet.id
}

# Backend
resource "google_compute_region_backend_service" "appsbroker_backend" {
  load_balancing_scheme = "INTERNAL_MANAGED"
  region                          = var.region
  name                            = "appsbroker-backend"
  protocol                        = "HTTP"
  timeout_sec                     = 10
  connection_draining_timeout_sec = 300
  backend {
    group           = google_compute_region_instance_group_manager.appsbroker_igm.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  health_checks = [google_compute_health_check.health_check.id]
}
