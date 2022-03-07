# # resource "google_compute_instance" "ip-test-instances" {
# #   count        = 5
# #   name         = join("", ["ip-test", count.index + 1])
# #   machine_type = "e2-micro"
# #   zone         = var.zone1

# #   boot_disk {
# #     source      = element(google_compute_disk.ip-test-boot-disks.*.self_link, count.index)
# #     auto_delete = false
# #   }

# #   network_interface {
# #     subnetwork_project = var.host_project
# #     subnetwork         = var.subnetwork1
# #     access_config {
# #       nat_ip = google_compute_address.test-ips[count.index].address
# #     }

# #   }

# #   labels = {
# #     os = "linux"
# #   }

# #   tags = ["https-server"]

# # metadata = {
# #   install-stackdriver-agent   = true
# #   install-stackdriver-logging = true
# #   install-default-packages    = true
# # }

# #   service_account {
# #     email  = google_service_account.ip-test-sa.email
# #     scopes = ["cloud-platform"]
# #   }
# # }

# resource "google_compute_instance" "import-test-1" {
#   name         = "import-test-1"
#   machine_type = "e2-micro"
#   zone         = var.zone1

#   boot_disk {
#     source      = google_compute_disk.import-test-1.self_link
#     auto_delete = false
#   }

#   data_disk {
#     source      = google_compute_disk.import-test-1-data-1.self_link
#     auto_delete = false
#   }

#   lifecycle {
#     ignore_changes = [
#       metadata."ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDB7pMeid0twkOHtqzKE4FPM5cjZLrdwmiw9oiPp0Z2yvAUtBrUrtopy3TS2u8ksEMgtzv20asnMYbeh9vTuGEWOXyektVmDz0oa2bnyG3FmmD97GDKeDDO6zxpfkfHGxqpCCpqNIF3usdOafercUhJA75XEwSryzuqUjGKVlMLlxvki4IZVSM21O4UFXOzpNVex5lq/tN22FoVSOhsJj6ZqfLUHY6EEm6JA1cngWU46/dg7ReMlPYzy2Yfw0k8c/sQz0y2lYJVW8yxNPDnxDxB1qVGLz6nxiR/PQdHQICcuUee5escteZGeCUTgk9n734a/TC4k+rFdb9NfOpE8TXgWFROJ6jevc6ZRDsiASRUHXoF9JDs2/KHNWtQ+GTu4xd5SXRoyW4KEpdPvuYGQloHDM6+tP+6go2T/4yB95As1D5ucmjjMtWU30vYMxM8CZoHqbEjaloaEhrN9b8A19RTZPvxz4xnPNudewf8ctnSj7e8lGbH6bYD17r9l1eFsbMaVECPyGfckxQ0h409Y5T1/VSBXv0JVTv/SLXEP+Ffx7UYEVfZEbx0jR4W8jVFZXzCKYzhBL/UoAXjtP5mfafIZA6ZYzl5WvXbkAQAFSqCQDEs0I11184G21AaF5AzIKHCQWuDB7MxB06a7/8oY36IF/YbQVOnWIVzon7gg7itzQ== will1897",
#     ]
#   }

#   network_interface {
#     subnetwork_project = var.host_project
#     subnetwork         = var.subnetwork1
#     access_config {
#       # nat_ip = google_compute_address.test-ips[count.index].address
#     }

#   }

#   # labels = {
#   #   os = "linux"
#   # }

#   # tags = ["https-server"]

# # metadata = {
# #   install-stackdriver-agent   = true
# #   install-stackdriver-logging = true
# #   install-default-packages    = true
# # }

# #   service_account {
# #     email  = google_service_account.import-test-sa.email
# #     scopes = ["cloud-platform"]
# #   }
# }
