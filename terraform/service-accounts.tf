resource "google_service_account" "ip-test-sa" {
  account_id   = "ip-test-sa"
  display_name = "Test instances service account"
}