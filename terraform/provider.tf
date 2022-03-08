provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = "1.1.6"

  backend "gcs" {
    bucket = "slamtf-state"
    prefix = "slam-environment-1981"
  }
}