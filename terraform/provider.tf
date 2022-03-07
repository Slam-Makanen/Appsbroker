provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_version = "1.0.11"

  backend "gcs" {
    bucket = "slam-tfstate"
    prefix = "slam-environment-1981"
  }
}