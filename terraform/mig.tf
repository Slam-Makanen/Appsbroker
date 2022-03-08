resource "google_compute_region_instance_group_manager" "appsbroker_igm" {
  #   provider = google-beta
  name    = "appsbroker-igm"
  project = var.project_id
  region  = var.region
  named_port {
    name = "http"
    port = 80
  }
  auto_healing_policies {
    health_check      = "https://www.googleapis.com/compute/beta/projects/slam-environment-1981/global/healthChecks/appsbroker-hc"
    initial_delay_sec = 300
  }


  base_instance_name = "appsbroker"

  version {
    name              = "0-1622787928774"
    instance_template = google_compute_instance_template.appsbroker_instance_template.id
  }


}


resource "google_compute_region_autoscaler" "autoscaler" {
  #   provider = google
  name    = "appsbroker-autoscaler"
  project = var.project_id
  region  = var.region

  target = google_compute_region_instance_group_manager.appsbroker_igm.self_link

  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 1
    mode            = "OFF"
    cooldown_period = 120
    cpu_utilization {
      target = 0.8
    }

  }
  lifecycle {
    ignore_changes = [
      autoscaling_policy[0].mode,
    ]
  }
}

resource "google_compute_health_check" "health_check" {
  name                = "appsbroker-hc"
  check_interval_sec  = 10
  unhealthy_threshold = 10
  timeout_sec         = 10
  healthy_threshold   = 2

  http_health_check {
    port         = "80"
    request_path = "/*"
  }
}