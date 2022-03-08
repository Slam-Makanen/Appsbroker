
resource "google_compute_forwarding_rule" "appsbroker_fwd_rule" {
  name                  = "appsbroker-forwarding-rule"
  region                = var.region
  ip_address            = google_compute_address.static_int_lb_ip.address
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.appsbroker_backend.id
  ports                 = [80]
  network               = var.network
  subnetwork            = var.subnet
  network_tier          = "PREMIUM"
}

resource "google_compute_region_backend_service" "appsbroker_backend" {
  load_balancing_scheme = "INTERNAL"

  backend {
    group = google_compute_region_instance_group_manager.appsbroker_igm.instance_group
  }

  region                          = var.region
  name                            = "appsbroker-backend"
  protocol                        = "TCP"
  timeout_sec                     = 10
  connection_draining_timeout_sec = 300

  health_checks = [google_compute_health_check.health_check.id]
}


resource "google_compute_address" "static_int_lb_ip" {
  name         = "static-int-lb-ip"
  subnetwork   = var.subnet
  address_type = "INTERNAL"
  address      = "10.14.233.74"
  region       = var.region
}