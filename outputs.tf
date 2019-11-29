output "get_credentials_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.gcloud_cluster.name} --zone ${google_container_cluster.gcloud_cluster.location} --project ${google_container_cluster.gcloud_cluster.project}"
}

output "gcloud_cluster_zone" {
  value = google_container_cluster.gcloud_cluster.location
}

output "gcloud_cluster_endpoint" {
  value = google_container_cluster.gcloud_cluster.endpoint
}

output "gcloud_cluster_network" {
  value = google_container_cluster.gcloud_cluster.network
}