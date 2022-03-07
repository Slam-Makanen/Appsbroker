provider "google" {
  project = var.project_id
  region  = var.region
  version = "3.31.0"
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  version = "3.31.0"
}

terraform {
  required_version = "0.13.5"

  backend "gcs" {
    bucket = "slam-tfstate"
    prefix = "ops-will-west"
  }
}