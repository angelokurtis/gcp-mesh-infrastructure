terraform {
  required_version = ">= 0.11.13"
}

provider "google" {
  project = var.gcloud_project
  region = var.gcloud_region
  credentials = file("./gcp_secret.json")
}

resource "google_container_cluster" "gcloud_cluster" {
  name = var.cluster_name
  location = data.google_container_engine_versions.engine_versions.location

  node_pool {
    initial_node_count = 3

    management {
      auto_repair = true
      auto_upgrade = true
    }

    node_config {
      machine_type = "n1-standard-2"
      oauth_scopes = [
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/trace.append"
      ]
    }
  }
}

data "google_container_engine_versions" "engine_versions" {
  location = data.google_compute_zones.regions.names[0]
}

data "google_compute_zones" "regions" {
  project = var.gcloud_project
  region = var.gcloud_region
}
