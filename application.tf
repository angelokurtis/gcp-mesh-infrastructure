resource "kubernetes_namespace" "application_namespace" {
  metadata {
    labels = {
      istio-injection = "enabled"
    }

    name = "application"
  }
  depends_on = [
    "google_container_cluster.gcloud_cluster"
  ]
}