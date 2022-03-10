variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "GCP primary region identifier"
  type        = string
}

variable "zone" {
  description = "GCP primary zone identifier"
  type        = string
}

variable "zones" {
  description = "GCP zone identifier"
  type        = list(any)
}

variable "network" {
  description = "GCP VPC network"
  type        = string
}

variable "subnet" {
  description = "GCP primary VPC subnetwork"
  type        = string
}

variable "host_project" {
  description = "GCP Host project"
  type        = string
}

