# Allow all access from IAP and health check ranges
resource "google_compute_firewall" "fw_iap" {
  name          = "int-lb-fw-allow-iap-hc"
  provider      = google-beta
  direction     = "INGRESS"
  network       = google_compute_network.int_lb_network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
  }
}

# Allow http from proxy subnet to backends
resource "google_compute_firewall" "fw_int_lb_to_backends" {
  name          = "int-lb-fw-allow-int-lb-to-backends"
  provider      = google-beta
  direction     = "INGRESS"
  network       = google_compute_network.int_lb_network.id
  source_ranges = ["10.0.0.0/24"]
  target_tags   = ["http-server"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
}