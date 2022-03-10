resource "google_compute_network" "private_network" {
  provider = google-beta

  name = "private-network"
}

### Reserve static IP address
resource "google_compute_global_address" "private_ip_address_sql" {
  provider = google-beta

  name          = "private-ip-address-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

#VPC Connector
resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address_sql.name]
}

# SQL Instance
resource "google_sql_database_instance" "appsbroker_sql" {

  name                = "appsbroker-db-2"
  database_version    = "MYSQL_5_7"
  region              = var.region
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    disk_size         = 10
    disk_type         = "PD_HDD"
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.id

    }
  }
}