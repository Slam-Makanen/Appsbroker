resource "google_storage_bucket" "blob_store" {
  name          = "${var.project_id}-blob-store"
  location      = var.region
  storage_class = "STANDARD"
}
