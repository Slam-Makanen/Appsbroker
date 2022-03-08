# module "gce-advanced-container" {
#   source  = "terraform-google-modules/container-vm/google"
#   version = "~> 2.0"

#   container = {
#     image = "eu.gcr.io/bmg-cashmatch-staging/bmg-cashmatch"

#     securityContext = {
#       privileged : true
#     }

#     env = [
#       {
#         name  = "SPRING_PROFILES_ACTIVE"
#         value = "gcp.stag"
#       }
#     ],

#     restart_policy = "OnFailure"
#   }
# }

resource "google_compute_instance_template" "appsbroker_instance_template" {
  name = "appsbroker-template-green"

  # tags = ["cashmatch-web-staging", "allow-corporate-access", "allow-healthchecks", "allow-proxy-connection", "allow-vpn-access", "bmg-frontend-proxy", "bmg-proxy-access", "bmg-cashmatch", "bmg-cashmatch-web", "allow-egress-appstaging", "cashmatch"]

  instance_description = "appsbroker instances"
  machine_type         = "e2-micro"
  can_ip_forward       = false

  disk {
    source_image = "projects/cos-cloud/global/images/family/cos-stable"
    auto_delete  = true
    boot         = true
    disk_size_gb = "20"
    disk_type    = "pd-standard"
  }


  network_interface {
    network    = var.network
    subnetwork = var.subnet
  }

  # metadata = merge(var.additional_metadata, map("gce-container-declaration", module.gce-advanced-container.metadata_value))

  # labels = {
  #   appsbroker-os = "cos"
  # }

  # service_account {
  #   email  = google_service_account.cashmatch-staging-sva.email
  #   scopes = ["cloud-platform"]
  # }
}