# resource google_compute_disk "ip-test-boot-disks" {
#   count = 5
#   name  = join("", ["ip-test", count.index + 1, "-disk01-test-boot"])
#   type  = "pd-ssd"
#   zone  = var.zone1
#   image = "centos-7"
# }
# resource "google_compute_disk" "import-test-1-data-1" {
#   name = "import-test-1-data-1"
#   type = "pd-balanced"
#   zone = var.zone1
#   size = "20"
# }