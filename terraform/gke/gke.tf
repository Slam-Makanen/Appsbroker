locals {
  gke_local_labels = {
    rax-project-name = var.project_id
  }
}

# GKE Cluster ###############################
resource "google_container_cluster" "apps_cluster" {
  name               = "appsbroker-cluster"
  provider           = google-beta
  location           = var.region
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  min_master_version = "1.21.6-gke.1503"
  network            = var.network
  subnetwork         = var.subnet
  node_locations     = var.zones
  # ip_allocation_policy {
  #   cluster_secondary_range_name  = "will-west-ops-test"
  #   services_secondary_range_name = "will-west-test-services"
  # }
  release_channel {
    channel = "STABLE"
  }

  network_policy {
    provider = "CALICO"
    enabled  = true
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }
    http_load_balancing {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.48/28"
  }

  workload_identity_config {
    identity_namespace = "${var.project_id}.svc.id.goog"
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "00:00"
    }
  }

  remove_default_node_pool = true
  initial_node_count       = 1
}

# Worker NodePool ########################
resource "google_container_node_pool" "appsbroker_preemptible_nodes" {
  name       = "will-west-appsbroker-nodepool"
  provider   = google-beta
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible     = true
    machine_type    = "e2-medium"
    disk_size_gb    = 10
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    # service_account = google_service_account.gke_sva.email
    # tags            = ["gke-prod"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

}