# resource "google_compute_address" "ip-test-ip" {
#   name   = "ip-test-ip"
#   region = var.region1
# }

# resource "google_compute_address" "ip-test-2-ip" {
#   name   = "ip-test-2-ip"
#   region = var.region1
# }

# resource "google_compute_address" "ip-test-3-ip" {
#   name   = "ip-test-3-ip"
#   region = var.region1
# }

# resource "google_compute_address" "ip-test-4-ip" {
#   name   = "ip-test-4-ip"
#   region = var.region1
# }

# resource "google_compute_address" "ip-test-5-ip" {
#   name   = "ip-test-5-ip"
#   region = var.region1
# }

# resource "google_compute_address" "test-ips" {
#   count  = 5
#   name   = join("", ["ip-test", count.index + 1, "-ip"])
#   region = var.region1
# }
