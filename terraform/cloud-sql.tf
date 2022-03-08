resource "google_compute_network" "private_network" {
  provider = google-beta

  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address_sql" {
  provider = google-beta

  name          = "private-ip-address-sql"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address_sql.name]
}

resource "random_id" "appsbroker_db" {
  byte_length = 4
}

####### SQL Instance
resource "google_sql_database_instance" "appsbroker_sql" {

  name             = "appsbroker-db"
  database_version = "POSTGRES_12"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"

    disk_size         = 10
    disk_type         = "PD_STANDARD"
    availability_type = "ZONAL"

    backup_configuration {
      enabled                        = true
      start_time                     = "01:00"
      point_in_time_recovery_enabled = false
    }

    maintenance_window {
      day  = 7
      hour = "0"
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.private_network.id

    }
  }
}