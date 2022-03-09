# Blob storage
resource "google_storage_bucket" "blob_store" {
  name          = "appsbroker-blob-store"
  location      = var.region
  storage_class = "STANDARD"
}
