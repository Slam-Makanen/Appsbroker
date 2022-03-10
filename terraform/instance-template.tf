# instance template
resource "google_compute_instance_template" "appsbroker_instance_template" {
  name         = "appsbroker-template-green"
  provider     = google-beta
  machine_type = "e2-micro"
  tags         = ["http-server"]

  metadata_startup_script = "service my-app start"

  network_interface {
    network    = google_compute_network.int_lb_network.id
    subnetwork = google_compute_subnetwork.int_lb_subnet.id
  }
  disk {
    source_image = "projects/slam-environment-1981/global/images/apps-hello"
    auto_delete  = true
    boot         = true
  }

  lifecycle {
    create_before_destroy = true
  }
}